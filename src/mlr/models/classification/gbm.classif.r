#' @include learnerR.r
roxygen()
#' @include WrappedModel.R
roxygen()
#' @include train.learner.r
roxygen()
#' @include pred.learner.r
roxygen()
#' @include task.classif.r
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
      
      par.set = makeParameterSet(      
          makeDiscreteLearnerParameter(id="distribution", default="bernoulli", vals=c("bernoulli", "adaboost")),
          makeIntegerLearnerParameter(id="n.trees", default=100L, lower=1L),
          makeIntegerLearnerParameter(id="interaction.depth", default=1L, lower=1L),
          makeIntegerLearnerParameter(id="n.minobsinnode", default=10L, lower=1L),
          makeNumericLearnerParameter(id="shrinkage", default=0.001, lower=0),
          makeNumericLearnerParameter(id="bag.fraction", default=0.5, lower=0, upper=1),
          makeNumericLearnerParameter(id="train.fraction", default=1, lower=0, upper=1)
      )
      callNextMethod(.Object, pack="gbm", desc=desc,	
          par.set=par.set, par.vals=list(distribution = "bernoulli"))
		}
)


#' @rdname train.learner

setMethod(
		f = "train.learner",
		signature = signature(
				.learner="classif.gbm", 
				.task="ClassifTask", .subset="integer" 
		),
		
		def = function(.learner, .task, .subset,  ...) {
			f = .task["formula"]
			d = get.data(.task, .subset, class.as="01")
      if (.task["has.weights"])
        gbm(f, data=d, keep.data=FALSE, verbose=FALSE, weights=.task["weights"][.subset], ...)
      else  
        gbm(f, data=d, keep.data=FALSE, verbose=FALSE, ...)
		}
)

#' @rdname pred.learner

setMethod(
		f = "pred.learner",
		signature = signature(
				.learner = "classif.gbm", 
				.model = "WrappedModel", 
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

