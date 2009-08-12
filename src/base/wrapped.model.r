#' @include task.learn.r
roxygen()

#---------------- class model --------------------------------------------

#' \describe{	
#' A classifier model is generated by \code{\link{train}}. It consists of the learn.task,
#' the classification model, the used hyperparameters and a vector specifying the cases of the training sample.}  
#' 
#' \cr\cr\bold{Slots:}
#'  \describe{	
#'   \item{\code{learn.task [\linkS4class{learn.task}]}}{Specifies classifier and classification task }
#'   \item{\code{learner.model [external.model]}}{External model from existing R packages like lda, rpart, etc}
#'   \item{\code{subset [integer]}}{An index vector specifying the cases of the training sample. }
#'   \item{\code{parset [list]}}{Contains the hyperparameters of the train function. If empty no parameters were used.}
#'  }
#' 
#'  @examples  
#'  see \link{train}
#' 
#'  @title model
#'  @importFrom stats predict
#'  @export
 
setClass(
		"wrapped.model",
		representation = representation(
				learn.task = "learn.task",
				learner.model = "ANY",
				subset = "numeric",
				parset = "list"
		)
)

setClass(
		"wrapped.classif.model",
		contains = c("wrapped.model")
)

setClass(
		"wrapped.regr.model",
		contains = c("wrapped.model")
)



#---------------- predict --------------------------------------------



#setGeneric(
#  name = "predict",
#  def = function(model, newdata, ...) {
#    if (missing(newdata)) {
#      tmp <- model@learn.task
#      newdata <- tmp@data[model@subset,]
#    }
#    standardGeneric("predict")
#  }
#)





setMethod(
		f = "as.character",
		signature = signature("wrapped.model"),
		def = function(x) {
			ps <- paste(names(x@parset), x@parset, sep="=", collapse=" ")
			return(
					paste(
							"Learner model for ", x@learn.task@wrapped.learner@learner.name, "\n",  
							"Hyperparameters: ", ps, "\n",
							"Trained on obs: ", length(x@subset), "\n",
							sep=""
					)
			)
		}
)


setMethod(
		f = "print",
		signature = signature("wrapped.model"),
		def = function(x, ...) {
			cat(as.character(x))
		}
)


setMethod(
		f = "show",
		signature = signature("wrapped.model"),
		def = function(object) {
			cat(as.character(object))
		}
)


setMethod(
		f = "[",
		signature = signature("wrapped.model"),
		def = function(x,i,j,...,drop) {
			if (i == "learn.task"){
				return(x@learn.task)
			}
			if (i == "subset"){
				return(x@subset)
			}
			if (i == "parset"){
				return(x@parset)
			}
			if (i == "learner.model"){
				return(x@learner.model)
			}
			
			y <- x@learn.task[i,j,...,drop]
			return(y)
		}
)











