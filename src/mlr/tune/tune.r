#todo: check whether optimization can be paralleized if req. by user

#' @include LearnTask.R
roxygen()


#todo instantiate resample description for others than grid search????

#' Optimizes the hyperparameters of a learner for a classification or regression problem.
#' Allows for different optimization methods, such as grid search, evolutionary strategies 
#' or sequential parameter optimization. You can select such an algorithm (and its settings)
#' by passing a corresponding control object. For a complete list of implemented algorithms look at the 
#' subclasses of [\code{\linkS4class{tune.control}}].
#'
#' @param learner [\code{\linkS4class{learner}} or string]\cr 
#'   Learning algorithm. See \code{\link{learners}}.  
#' @param task [\code{\linkS4class{LearnTask}}] \cr
#'   Learning task.   
#' @param resampling [\code{\linkS4class{ResampleInstance}}] or [\code{\linkS4class{ResampleDesc}}]\cr
#'   Resampling strategy to evaluate points in hyperparameter space. If you pass a description, 
#'   it is instantiated once at the beginning by default, so all points are evaluated on the same training/test sets.
#'   If you want to change that behaviour, look at the control object. 	
#' @param par.set [\code{\linkS4class{ParameterSet}}] \cr
#'   Collection of parameters and their constraints for optimization.   
#' @param control [\code{\linkS4class{tune.control}}] \cr
#'   Control object for search method. Also selects the optimization algorithm for tuning.   
#' @param measures [list of \code{\linkS4class{measure}}]\cr
#'   Performance measures to evaluate. The first measure, aggregated by the first aggregation function is optimized during tuning, others are simply evaluated.  
#' @param log.fun [function(learner, task, resampling, measure, par.set, control, opt.path, x, y)]\cr
#'   Called after every hyperparameter evaluation. Default is to print performance via mlr logger. 
#' 
#' @return \code{\linkS4class{opt.result}}.
#' @export
#' @seealso \code{\link{makeTuneWrapper}} 
#' @title Hyperparameter tuning.


tune <- function(learner, task, resampling, measures, par.set, control, log.fun) {
  if (is.character(learner))
    learner <- makeLearner(learner)
  if (is(resampling, "ResampleDesc") && control@same.resampling.instance)
    resampling = make.res.instance(resampling, task=task)
	if (missing(measures))
		measures = default.measures(task)
  if (is(measures, "Measure"))
    measures = list(measures)   
  if (length(par.set@pars) == 0)
    stop("No parameters were passed!")
  if (missing(log.fun))
    log.fun = log.fun.tune
  
  cl = as.character(class(control))
	sel.func = switch(cl,
			grid.control = tune.grid,
#			pattern = tune.ps,
			cmaes.control = tune.cmaes,
			optim.control = tune.optim,
      diceoptim.control = tune.diceoptim,
      stop(paste("Tuning algorithm for", cl, "does not exist!"))
	)		
	
	if (missing(control)) {
		stop("You have to pass a control object!")
	}
	
  if(any(sapply(par.set@pars, function(x) is(x, "LearnerParameter"))))
    stop("No par.set parameter in 'tune' can be of class 'LearnerParameter'! Use basic parameters instead to describe you region of interest!")        
  
  opt.path = makeOptPathFromMeasures(names(par.set@pars), measures)
  or = sel.func(learner, task, resampling, measures, par.set, control, opt.path, log.fun)
	
	or@x = trafoVal(par.set, or@x)
	return(or)			
}


