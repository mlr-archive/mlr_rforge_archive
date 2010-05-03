#' @include object.r
roxygen()
#' @include data.desc.r
roxygen()
#' @include task.desc.r
roxygen()

#' A learning task is a general description object for a machine learning experiment. 
#' It wraps the data source and specifies - through its subclasses - the type of the task (e.g. classification or regression), 
#' the target variable and other details of the problem. As this is just an abstract base class, 
#' you should not instantiate it directly but use the inheriting classes and their factory methods.
#'  
#' Getter.\cr
#' 
#' \describe{
#'  \item{id [string]}{Id string of task.}
#'	\item{label [string]}{Label string of task.}
#' 	\item{data [data.frame]. Optional parameters: row, col}{The data.frame is returned, possibly indexed by row/col}
#'  \item{size [integer]}{Number of cases.}
#'	\item{target.name [string]}{The name of the target variable.}
#'  \item{input.names [character]}{The names of the input variables.}
#'  \item{excluded [character]}{Names of excluded variables.}
#'  \item{targets [character]. Optional parameters: row}{If row is missing all target values are returned. Otherwise they are indexed by row.}
#'  \item{weights [numeric]. Optional parameters: row}{If row is missing all case weights are returned. Otherwise they are indexed by row.}
#'  \item{class.levels [character]}{Levels of target factor for classification.}
#'  \item{class.nr [integer]}{Number of class labels for classification.}
#'  \item{is.binary [boolean]}{Binary classification task?}
#'  \item{costs [matrix]}{Cost matrix, NULL if not available.}
#'  \item{positive [string]}{Positive class label for binary classification.}
#'  \item{negative [string]}{Negative class label for binary classification.}
#' }
#' 
#' @exportClass learn.task
#' @seealso \code{\link{make.task}}
#' @title learn.task


setClass(
		"learn.task",
		contains = c("object"),
		representation = representation(
				data = "data.frame",
				weights = "numeric",
				data.desc = "data.desc",
				task.desc = "task.desc"
		)
)


#---------------- constructor---- -----------------------------------------------------

#' Constructor.

setMethod(
		f = "initialize",
		signature = signature("learn.task"),
		def = function(.Object, data, weights, data.desc, task.desc) {
			
			# constructor is called in setClass of inheriting classes 
			# wtf chambers, wtf!
			if(missing(data))
				return(.Object)					
			
			.Object@data = data
			.Object@weights = weights
			.Object@data.desc = data.desc
			.Object@task.desc = task.desc
			
#			.Object@data.desc <- make.data.desc(.Object["data"], target)
			
			return(.Object)
		}
)

#' Getter.
#' @rdname learn.task-class

setMethod(
		f = "[",
		signature = signature("learn.task"),
		def = function(x,i,j,...,drop) {
			check.getter(x,i,j,...,drop)
			args = list(...)
			argnames = names(args)
			
			dd = x@data.desc
			td = x@task.desc
			row = args$row
			
			if (i == "target.name") {
				return(td["target"])
			}
			if (i == "input.names"){
				return(setdiff(colnames(x@data), c(x["excluded"], x["target.name"])))
			}
			if (i == "has.weights"){
				return(length(x@weights) > 0)
			}
			
			
			if (is.null(row))
				row = 1:nrow(x@data)
			
			if (i == "targets") {
				return(x@data[row, x["target.name"]])
			}
			if (i == "weights") {
				if (!x["has.weights"])
					return(NULL)
				return(x@weights[row])
			}
			if (i == "data"){
				if ("excluded" %in% argnames)
					v = colnames(x@data)
				else 
					v = setdiff(colnames(x@data), x["excluded"])
				if ("select" %in% argnames)
					v = args$select
				if (missing(drop))
					drop = (length(v) == 1)
				return(x@data[row, v, drop=drop])				
			}
			y = td[i]
			if (!is.null(y))
				return(y)
			y = dd[i]
			if (!is.null(y))
				return(y)
			
			callNextMethod()
		}
)



#---------------- restrict.learn.task -----------------------------------------------------

restrict.learn.task <- function(learn.task, subset) {
	learn.task@data <- learn.task@data[subset,]
	return(learn.task)
}


