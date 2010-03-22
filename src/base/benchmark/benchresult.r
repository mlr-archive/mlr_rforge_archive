
setClass(
		"bench.result",                                                     
		representation = representation(
				perf = "array",
				tuned.pars = "list", 
				conf.mats = "list",
				resamplings = "list"
		)
)




#' Getter.
#' @param x bench.result object
#' @param i [character]
#' \describe{
#'   \item{perf}{Performance matrix.}
#'   \item{tuned.pars}{Values of tuned paramters. NA if no tuning was done.}
#'   \item{conf.mats}{Confusion matrices - only for classification.}
#' }
#' @param j [integer or character] \cr Select subset of learners.
#' 
#' @rdname getter,learn.task-method
#' @aliases learn.task.getter getter,learn.task-method
#' @title Getter for learn.task

setMethod(
		f = "[",
		signature = signature("bench.result"),
		def = function(x,i,j,...,drop) {
			
			args = list(...)
			arg.names = names(args)
			
			task = args$task
			if (is.null(task))
				task = dimnames(x@perf)[[4]]
			learner = args$learner
			if (is.null(learner))
				learner = dimnames(x@perf)[[2]]
			measure = args$measure
			if (is.null(measure))
				measure = dimnames(x@perf)[[3]]
			iter = args$iter
			if (is.null(iter))
				iter = dimnames(x@perf)[[1]]
			aggr = args$aggr
			if (is.null(aggr))
				aggr=list() 
			else {
				ns = names(aggr)
				if (is.null(ns) || any(ns == ""))
					stop("Aggregation functions have to be passed as a list with names!")
			}
			
			if (!missing(i)) {
				if (i == "tuned.pars"){
					if (missing(j))
						j = 1:ncol(x@perf)
					if (length(j) == 1)
						return(x@tuned.pars[[j]])
					else
						return(x@tuned.pars[j])
				}
				if (i == "conf.mats"){
					if (missing(j))
						j = 1:ncol(x@perf)
					if (length(j) == 1)
						return(x@conf.mats[[j]])
					else
						return(x@conf.mats[j])
				}
			}
			p = x@perf[iter, learner, measure, task, drop=FALSE]
			if (length(aggr) > 0) {
				p = lapply(aggr, function(f) apply(p, c(2,3,4), f))
				p = Reduce(function(v,w) abind(v,w, along=2), p)
				# combine aggr names with measure names
				dimnames(p)[[2]] = sapply(names(aggr), function(a) paste(a, measure, sep="."))
			}
			return(p)
		}
)





#' Conversion to string.

setMethod(
		f = "to.string",
		signature = signature("bench.result"),
		def = function(x) {
			p = x[aggr=list(mean=mean, sd=sd)]
			p = paste(capture.output(p), collapse="\n")
		}
)


#' Prints the object by calling as.character.

setMethod(
		f = "print",
		signature = signature("bench.result"),
		def = function(x, ...) {
			cat(to.string(x))
		}
)

#' Shows the object by calling as.character.

setMethod(
		f = "show",
		signature = signature("bench.result"),
		def = function(object) {
			cat(to.string(object))
		}
)