#' @include learnerR.r
roxygen()
#' @include wrapped.model.r
roxygen()
#' @include train.learner.r
roxygen()
#' @include pred.learner.r
roxygen()
#' @include task.classif.r
roxygen()

setClass(
		"classif.kknn", 
		contains = c("rlearner.classif")
)


setMethod(
		f = "initialize",
		signature = signature("classif.kknn"),
		def = function(.Object) {
			
			desc = c(
					oneclass = FALSE,
					twoclass = TRUE,
					multiclass = TRUE,
					missings = FALSE,
					doubles = TRUE,
					factors = TRUE,
					prob = TRUE,
					decision = FALSE,
					weights = FALSE,
					costs = FALSE
			)
			#todo: find out what ykernel and contrasts really do 
			par.descs = list(
        integer.learner.parameter(id="k", default=7L, lower=1L),
				numeric.learner.parameter(id="distance", default=2, lower=0),
				discrete.learner.parameter(id="kernel", default="triangular", 
						vals=list("rectangular", "triangular", "epanechnikov", "biweight", "triweight", "cos", "inv", "gaussian"))
			)
			callNextMethod(.Object, pack="kknn", desc=desc, par.descs=par.descs)
		}
)

#' @rdname train.learner

setMethod(
		f = "train.learner",
		signature = signature(
				.learner="classif.kknn", 
				.task="classif.task", .subset="integer" 
		),
		
		def = function(.learner, .task, .subset,  ...) {
			list(td=.task["desc"], data=get.data(.task, .subset), parset=list(...))
		}
)

#' @rdname pred.learner

setMethod(
		f = "pred.learner",
		signature = signature(
				.learner = "classif.kknn", 
				.model = "wrapped.model", 
				.newdata = "data.frame", 
				.type = "character" 
		),
		
		def = function(.learner, .model, .newdata, .type, ...) {
			m = .model["learner.model"]
			f = m$td["formula"]
			# this is stupid but kknn forces it....
			.newdata[, m$target] <- 0
			pars <- list(formula=f, train=m$data, test=.newdata)  
			pars <- c(pars, m$parset, list(...))
			m <- do.call(kknn, pars)
			if (.type=="response")
				return(m$fitted.values)
			else 
				return(m$prob)
		}
)	




