#' @include learnerR.r
roxygen()
#' @include task.regr.r
roxygen()


setClass(
		"regr.ridge", 
		contains = c("rlearner.regr")
)


setMethod(
		f = "initialize",
		signature = signature("regr.ridge"),
		def = function(.Object) {

			desc = c(
					missings = TRUE,
					doubles = TRUE,
					factors = TRUE,
					weights = FALSE
			)
			
			callNextMethod(.Object, pack="penalized", desc=desc)
		}
)



#' @rdname train.learner


setMethod(
		f = "train.learner",
		signature = signature(
				.learner="regr.ridge", 
				.task="regr.task", .subset="integer" 
		),
		
		def = function(.learner, .task, .subset, ...) {
			f = .task["formula"]
			args = list(...)
			i = which(names(args) == "lambda") 
			if (length(i) > 0) {
				names(args)[i] = "lambda2"
			}
			pars <- list(f, data=get.data(.task, .subset))
			pars <- c(pars, args)
			do.call(penalized, pars)
		}
)


#' @rdname pred.learner

setMethod(
		f = "pred.learner",
		signature = signature(
				.learner = "regr.ridge", 
				.model = "wrapped.model", 
				.newdata = "data.frame", 
				.type = "missing" 
		),
		
		def = function(.learner, .model, .newdata, ...) {
			m <- .model["learner.model"]
			.newdata[, .model["target"]] <- 0
			predict(m, data=.newdata,  ...)[,"mu"]
		}
)	

