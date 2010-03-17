#' @include wrapped.learner.classif.r
roxygen()

setClass(
		"gbm.classif", 
		contains = c("wrapped.learner.classif")
)


################ TO DO : TEST!!!!!!!

#----------------- constructor ---------------------------------------------------------
#' Constructor.
#' @title GBM Constructor
setMethod(
		f = "initialize",
		signature = signature("gbm.classif"),
		def = function(.Object) {
			
			desc = new("classif.props",
					supports.multiclass = FALSE,
					supports.missing = FALSE,
					supports.numerics = TRUE,
					supports.factors = TRUE,
					supports.characters = FALSE,
					supports.probs = TRUE,
					supports.decision = FALSE,
					supports.weights = FALSE,
					supports.costs = FALSE
			)			
			.Object <- callNextMethod(.Object, learner.name="Gradient Boosting Machine", learner.pack="gbm", learner.props=desc)
			.Object <- set.train.par(.Object, distribution="adaboost", verbose=FALSE)
			.Object <- set.predict.par(.Object, type="link", single.tree = FALSE)
			return(.Object)
		}
)



setMethod(
		f = "train.learner",
		signature = signature(
				.wrapped.learner="gbm.classif", 
				.targetvar="character", 
				.data="data.frame", 
				.weights="numeric", 
				.costs="matrix", 
				.type = "character" 
		),
		
		def = function(.wrapped.learner, .targetvar, .data, .weights, .costs, .type,  ...) {
			f = as.formula(paste(.targetvar, "~."))
			gbm(f, data=.data, weights=.weights, ...)
		}
)

setMethod(
		f = "predict.learner",
		signature = signature(
				.wrapped.learner = "gbm.classif", 
				.wrapped.model = "wrapped.model", 
				.newdata = "data.frame", 
				.type = "character" 
		),
		
		def = function(.wrapped.learner, .wrapped.model, .newdata, .type, ...) {
			m <- .wrapped.model["learner.model"]
			predict(m, newdata=.newdata, n.trees=length(m$trees), ...)
		}
)	

library(mlbench)
data(BreastCancer)
ct = make.classif.task(data=na.omit(BreastCancer), target="Class", excluded="Id")
m = train("gbm.classif", task=ct)

