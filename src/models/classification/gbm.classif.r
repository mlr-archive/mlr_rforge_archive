#' @include learnerR.r
roxygen()
#' @include wrapped.model.r
roxygen()
#' @include train.learner.r
roxygen()
#' @include pred.learner.r
roxygen()


setClass(
		"classif.gbm", 
		contains = c("rlearner.classif")
)



setMethod(
		f = "initialize",
		signature = signature("classif.gbm"),
		def = function(.Object) {
			
			desc = c(
					oneclass = FALSE,
					twoclass = TRUE,
					multiclass = FALSE,
					missings = TRUE,
					doubles = TRUE,
					factors = TRUE,
					prob = TRUE,
					decision = FALSE,
					weights = TRUE,
					costs = FALSE
			)			
      
      par.descs = list(      
          new("par.desc.disc", par.name="distribution", default="bernoulli", vals=c("bernoulli", "adaboost")),
          new("par.desc.num", par.name="n.trees", default=100L, lower=1L),
          new("par.desc.num", par.name="interaction.depth", default=1L, lower=1L),
          new("par.desc.num", par.name="n.minobsinnode", default=10L, lower=1L),
          new("par.desc.num", par.name="shrinkage", default=0.001, lower=0),
          new("par.desc.num", par.name="bag.fraction", default=0.5, lower=0, upper=1),
          new("par.desc.num", par.name="train.fraction", default=1, lower=0, upper=1)
      )
      callNextMethod(.Object, pack="gbm", desc=desc,	
          par.descs=par.descs, par.vals=list(distribution = "bernoulli"))
		}
)


#' @rdname train.learner

setMethod(
		f = "train.learner",
		signature = signature(
				.learner="classif.gbm", 
				.task="classif.task", .subset="integer", .vars="character" 
		),
		
		def = function(.learner, .task, .subset, .vars,  ...) {
			f = .task["formula"]
			d = get.data(.task, .subset, .vars, class.as.numeric=TRUE)
			gbm(get.formula, data=d, weights=.weights, keep.data=FALSE, verbose=FALSE, ...)
		}
)

#' @rdname pred.learner

setMethod(
		f = "pred.learner",
		signature = signature(
				.learner = "classif.gbm", 
				.model = "wrapped.model", 
				.newdata = "data.frame", 
				.type = "character" 
		),
		
		def = function(.learner, .model, .newdata, .type, ...) {
			m = .model["learner.model"]
			p = predict(m, newdata=.newdata, type="response", n.trees=length(m$trees), single.tree=FALSE, ...)
			levs = c(.model["negative"], .model["positive"])
			if (.type == "prob") {
				y = matrix(0, ncol=2, nrow=nrow(.newdata))
				colnames(y) = levs
				y[,1] = 1-p
				y[,2] = p
				return(y)
			} else {
				p = as.factor(ifelse(p > 0.5, levs[2], levs[1]))
				names(p) = NULL
				return(p)
			}
		}
)	


