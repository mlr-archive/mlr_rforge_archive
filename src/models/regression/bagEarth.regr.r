#' @include learnerR.r
roxygen()

setClass(
		"regr.bagEarth", 
		contains = c("rlearner.regr")
)


setMethod(
		f = "initialize",
		signature = signature("regr.bagEarth"),
		def = function(.Object) {
			
			desc = new("learner.desc.regr",
					missings = FALSE,
					numerics = TRUE,
					factors = TRUE,
					weights = FALSE
			)
			
			callNextMethod(.Object, pack="caret", desc=desc)
		}
)

#' @rdname train.learner

setMethod(
		f = "train.learner",
		signature = signature(
				.learner="regr.bagEarth", 
				.task="regr.task", .subset="integer", .vars="character" 
		),
		
		def = function(.learner, .task, .subset, .vars,  ...) {
			f = as.formula(paste(.task["target"], "~."))
			bagEarth(f, data=.task["data"][.subset, .vars], ...)
		}
)

#' @rdname pred.learner

setMethod(
		f = "pred.learner",
		signature = signature(
				.learner = "regr.bagEarth", 
				.model = "wrapped.model", 
				.newdata = "data.frame", 
				.type = "missing" 
		),
		
		def = function(.learner, .model, .newdata, .type, ...) {
			predict.bagEarth(.model["learner.model"], newdata=.newdata)
		}
)



