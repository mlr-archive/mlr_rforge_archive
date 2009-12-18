

setGeneric(
		name = "performance",
		def = function(true.y, pred.y, weights, loss, aggr) {
			
			if (is.factor(true.y))
				true.y = as.character(true.y)
			if (is.factor(pred.y))
				pred.y = as.character(pred.y)
			
			if (class(true.y) != class(pred.y))
				stop(paste("true.y and pred.y have incompatible types:", class(true.y), class(pred.y)))
			
			if(missing(weights)) {
				weights <- rep(1, length(true.y))
			}
			if(missing(loss)) {
				if (is.character(true.y))
					loss="zero-one"
				if (is.numeric(true.y))
					loss="squared"
			}
			if (is.character(loss))
				loss = make.loss(loss)
			if(missing(aggr)) {
				aggr = mean
			}
			standardGeneric("performance")
		}
)

#' \code{performance} measures the quality of predictions w.r.t. some loss function.
#' 
#' There are some more loss functions which you can use as performance measure, they are as follows:
#' For classification:
#' \describe{ 
#' 		\item{\code{smce}}{Summed misclassification error}
#' } 
#' 
#' For regression:
#' \describe{ 
#' 		\item{\code{sae}}{Sum of absolute errors}
#' 		\item{\code{mae}}{Median of absolute errors}
#' 		\item{\code{sse}}{Squared sum of errors}
#' 		\item{\code{mse}}{Mean squared error}
#' } 
#' 

#' @param	true.y [ANY] \cr
#' 			The data sets true labels.
#' @param 	pred.y [ANY] \cr
#' 			The predicted labels.
#' @param 	weights [\code{\link{numeric}}] \cr
#' 			An optional vector of weights to be used. Default is a weight of 1 for every case.
#' @param 	loss [\code{\linkS4Class{loss}} or \code{\link{character}}] \cr
#' 			Loss function. Default is "zero-one" for classifictaion and "squared" for regression.
#' 
#' @return The performance.
#' 
#' @export
#' @rdname performance
#' 
#' @usage performance(true.y, pred.y, weights, loss, aggr)
#'
#' @examples
#' data(iris) 
#' ct <- make.classif.task(data=iris, target="Species")
#' # specify train and test set indices
#' train.set <- seq(from=1L, to=150L, by=2L)
#' test.set <- seq(from=2L, to=150L, by=2L)
#' # train a model with the train set
#' m <- train("rpart.classif", ct, subset=train.set) 
#' # predict the class of the test set measures 
#' preds <- predict(m, newdata=iris[test.set,])
#' # evaluate the predictions, first with mean misclassification error as loss function (default)
#' performance(true.y = iris[test.set, "Species"], pred.y = preds)		
#' 
#' @title performance

setMethod(
		f = "performance",
		signature = signature(true.y="ANY", pred.y="ANY", weights="numeric", loss="loss", aggr="function"),
		def = function(true.y, pred.y, weights, loss, aggr) {
			ls = loss@fun(true.y, pred.y, weights)
			return(list(aggr=aggr(ls), vals=ls))
		}
)



