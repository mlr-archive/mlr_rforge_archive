#' @include resample.instance.r
#' @include resample.result.r
roxygen()




setGeneric(
		name = "resample.fit",
		def = function(learn.task, resampling, parset, vars, models, type) {
			if (missing(type))
				type <- "class"
			if (missing(parset))
				parset <- list()
			if (missing(vars))
				vars <- learn.task["input.names"]
			if (missing(models))
				models <- FALSE
			standardGeneric("resample.fit")
		}
)

#' Given the training and test indices (e.g. generated by cross-validation and generally specified by 
#' the \code{\linkS4class{resample.instance}} object) \code{resample.fit} 
#' fits the selected learner using the training sets and performs predictions for the test sets. These 
#' predictions are returned - encapsulated in a \code{\link{resample.result}} object. 
#' Optionally the fitted models are also stored.
#'
#' @param learn.task [\code{\linkS4class{learn.task}}] \cr
#'   Specifies the learning task for the problem.
#' @param resampling [\code{\linkS4class{resample.instance}}] \cr
#'   Specifies the training and test indices of the resampled data. 
#' @param parset [\code{\link{list}}]\cr A list of named elements which specify the hyperparameters of the learner.
#' @param vars [\code{\link{character}}] \cr Vector of variable names to use in training the model. Default is to use all variables.
#' @param models [\code{\link{logical}}] \cr If TRUE a list of the fitted models is included in the result.
#' @param type [\code{\link{character}}] \cr 
#' 		Only used for classification tasks; specifies the type of predictions -
#' 		either probability ("prob") or class ("class").
#' 	   
#'             
#' @return An object of class \code{\linkS4class{resample.result}}.
#' 
#' @export
#' @rdname resample.fit 
#' 
#' @usage resample.fit(learn.task, resample.instance, parset, vars, models, type)
#'
#' @examples
#' library(mlr) 
#' ct1 <- make.classif.task("lda", data=iris, target="Species")
#' ct2 <- make.classif.task("rpart.classif", data=iris, target="Species")
#' rin <- make.cv.instance(iters=3, size=nrow(iris))
#' f1 <- resample.fit(ct1, resample.instance=rin)	
#' f2 <- resample.fit(ct2, resample.instance=rin, parset=list(minsplit=10, cp=0.03))
#'  
#' @title resample.fit

setMethod(
		f = "resample.fit",
		signature = signature(learn.task="learn.task", resampling="resample.instance", parset="list", vars="character", models="logical", type="character"),
		def = function(learn.task, resampling, parset, vars, models, type) {
			df <- learn.task@data
			n <- nrow(df)  
			ps <- list()
			ms <- list()
			resample.instance <- resampling
			iters <- resample.instance["iters"]
			
			wrapper <- function(i) {
				resample.fit.iter(learn.task, resample.instance, parset, vars, type, i, return.model=models)
			}
			
			.ps <- .mlr.local$parallel.setup
			if (.ps$mode %in% c("snowfall", "sfCluster") && .ps$level == "resample") {
				sfExport("parset")
				if (!is.null(parent.frame()$caller) && !parent.frame()$caller == "tune") {
					sfExport("learn.task")
					sfExport("resample.instance")
				}
				rs <- sfClusterApplyLB(1:iters, wrapper)
			} else {
				rs <- lapply(1:iters, wrapper)
			}
			ps = lapply(rs, function(x) x$pred)
			if (models)			
				ms = lapply(rs, function(x) x$model)
			else
				ms = list()
			return(new("resample.result", ri.name=resample.instance["name"], ri.class=class(resample.instance), preds=ps, models=ms))
		}
)


setMethod(
		f = "resample.fit",
		signature = signature(learn.task="learn.task", resampling="resample.desc", parset="list", vars="character", models="logical", type="character"),
		def = function(learn.task, resampling, parset, vars, models, type) {
			i <- make.resample.instance(resampling, size=nrow(learn.task["data"]))
			resample.fit(learn.task, i, parset, vars, models, type)
		}
)


