#' @include wrapped.learner.classif.r
roxygen()

#' Wrapped learner for Localized Linear Discriminant Analysis from package \code{MASS}.
#' @title loclda
#' @seealso \code{\link[klaR]{loclda}}
#' @export
setClass(
		"loclda", 
		contains = c("wrapped.learner.classif")
)


#----------------- constructor ---------------------------------------------------------
#' Constructor.
#' @title loclda Constructor
setMethod(
		f = "initialize",
		signature = signature("loclda"),
		def = function(.Object) {
			train.fct <- "loclda" 
			predict.fct <- "predict" 
			
			desc = new("classif.props",
					supports.multiclass = TRUE,
					supports.missing = TRUE,
					supports.numerics = TRUE,
					supports.factors = TRUE,
					supports.characters = TRUE,
					supports.probs = TRUE,
					supports.weights = FALSE,
					supports.costs = FALSE
			)
			
			callNextMethod(.Object, learner.name="Localized LDA", learner.pack="klaR", learner.props=desc)
		}
)
setMethod(
		f = "train.learner",
		signature = signature(
				.wrapped.learner="lda", 
				.targetvar="character", 
				.data="data.frame", 
				.weights="numeric", 
				.costs="matrix", 
				.type = "character" 
		),
		
		def = function(.wrapped.learner, .targetvar, .data, .weights, .costs, .type,  ...) {
			f = as.formula(paste(.targetvar, "~."))
			loclda(f, data=.data, ...)
		}
)

setMethod(
		f = "predict.learner",
		signature = signature(
				.wrapped.learner = "loclda", 
				.task = "classif.task", 
				.wrapped.model = "wrapped.model", 
				.newdata = "data.frame", 
				.type = "character" 
		),
		
		def = function(.wrapped.learner, .task, .wrapped.model, .newdata, .type, ...) {
			p <- predict(.wrapped.model["learner.model"], newdata=.newdata, ...)
			if(.type=="class")
				return(p$class)
			else
				return(p$posterior)
		}
)	






