#' @include learnerR.r
roxygen()
#' @include task.regr.r
roxygen()

setClass(
		"regr.blackboost", 
		contains = c("rlearner.regr")
)


setMethod(
		f = "initialize",
		signature = signature("regr.blackboost"),
		def = function(.Object) {
			
			desc = c(
					missings = FALSE,
					doubles = TRUE,
					factors = TRUE,
					weights = TRUE
			)
			
			callNextMethod(.Object, pack="mboost", desc=desc)
		}
)

#' @rdname train.learner

setMethod(
		f = "train.learner",
		signature = signature(
				.learner="regr.blackboost", 
				.task="regr.task", .subset="integer" 
		),
		
		def = function(.learner, .task, .subset, ...) {
			xs = args.to.control(boost_control, c("mstop", "nu", "risk"), list(...))
			ys = args.to.control(ctree_control, c("teststat", "testtype", "mincriterion", "maxdepth"), xs$args)
			f = .task["formula"]
      args = c(list(f, data=get.data(.task, .subset), control=xs$control, tree_control=ys$control), ys$args)
      if (.task["has.weights"])
        args$weights = .task["weights"][.subset] 
			do.call(blackboost, args)
		}
)

#' @rdname pred.learner

setMethod(
		f = "pred.learner",
		signature = signature(
				.learner = "regr.blackboost", 
				.model = "wrapped.model", 
				.newdata = "data.frame", 
				.type = "missing" 
		),
		
		def = function(.learner, .model, .newdata, ...) {
			predict(.model["learner.model"], newdata=.newdata, ...)
		}
)	





