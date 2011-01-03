#' @include learnerR.r
roxygen()
#' @include wrapped.model.r
roxygen()
#' @include train.learner.r
roxygen()
#' @include pred.learner.r
roxygen()


setClass(
		"classif.qda", 
		contains = c("rlearner.classif")
)


setMethod(
		f = "initialize",
		signature = signature("classif.qda"),
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
			
      par.descs = list(
        new("par.desc.disc", par.name="method", default="moment", vals=c("moment", "mle", "mve", "t")),
        new("par.desc.double", par.name="nu", default=5L , lower=2L, requires=expression(method == "t"))
      )
      
			callNextMethod(.Object, pack="MASS", desc=desc, par.descs=par.descs)
		}
)

#' @rdname train.learner

setMethod(
		f = "train.learner",
		signature = signature(
				.learner="classif.qda", 
				.task="classif.task", .subset="integer", .vars="character" 
		),
		
		def = function(.learner, .task, .subset, .vars,  ...) {
			f = .task["formula"]
			qda(f, data=get.data(.task, .subset, .vars), ...)
		}
)

#' @rdname pred.learner

setMethod(
		f = "pred.learner",
		signature = signature(
				.learner = "classif.qda", 
				.model = "wrapped.model", 
				.newdata = "data.frame", 
				.type = "character" 
		),
		
		def = function(.learner, .model, .newdata, .type, ...) {
			p <- predict(.model["learner.model"], newdata=.newdata, ...)
			if(.type=="response")
				return(p$class)
			else
				return(p$posterior)
		}
)	


