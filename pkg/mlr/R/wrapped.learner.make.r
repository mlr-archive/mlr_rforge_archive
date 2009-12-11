setGeneric(
		name = "make.learner",
		def = function(name) {
			standardGeneric("make.learner")
		}
)



#' Creates a wrapped learner object.  
#' 
#' List of supported learning algorithms. The naming conventions are to add the package name as a prefix if
#' a learner is implemented in different packages and the suffix ".classif" if it can handle more than a
#' classification task.  
#' 
#' \itemize{ 
#' 		\item{\code{\linkS4class{adaboost}}}{Boosting from adabag package}
#' 		\item{\code{\linkS4class{kknn.classif}}}{k-Nearest Neighbor from kknn package}
#' 		\item{\code{\linkS4class{lda}}}{Linear Discriminant Analysis from MASS package}
#' 		\item{\code{\linkS4class{logreg}}}{Logistic Regression from stats package}
#' 		\item{\code{\linkS4class{mda}}}{Mixture Discriminant Analysis from mda package}
#' 		\item{\code{\linkS4class{naiveBayes}}}{Naive Bayes from e1071 package}
#' 		\item{\code{\linkS4class{qda}}}{Quadratic Discriminant Analysis from MASS package}
#' 		\item{\code{\linkS4class{randomForest.classif}}}{Random Forest from randomForest package}
#' 		\item{\code{\linkS4class{rda}}}{Regularized Discriminant Analysis from klaR package}
#' 		\item{\code{\linkS4class{rpart.classif}}}{Decision Tree from rpart package}
#' 		\item{\code{\linkS4class{kernlab.svm.classif}}}{Support Vector Machines from kernlab package}  
#' }
#' 
#' @param name [\code{\link{character}}] \cr
#'  	  Name of the learning algorithm.
#' 
#' @return An object of class \code{\linkS4class{wrapped.learner}}.
#' 
#' @export
#' @rdname make.learner
#' 
#' @usage make.learner(name)
#'  
#' @title make.learner


setMethod(
		f = "make.learner",
		signature = signature(
				name = "character"
		),
		
		def = function(name) {
			return(new(name))
		}
)

