#' @include task.learn.r
roxygen()

#' A classification task.  
#' Use \code{\link{makeClassifTask}} to create it.   
#' 
#' @exportClass ClassifTask
#' @title Classification task.
#' @seealso \code{\link{makeClassifTask}}


setClass(
		"ClassifTask",
		contains = c("LearnTask")
)



#' Constructor.
#' @title ClassifTask constructor

setMethod(
		f = "initialize",
		signature = signature("ClassifTask"),
		def = function(.Object, id, target, data, weights, blocking, control=control, costs, positive) {
			if (missing(data))
				return(make.empty(.Object))
			
      check.costs(costs, levels(data[, target]))

      td = new("task.desc", data, target, "ClassifTask", id, 
        length(weights) > 0, length(blocking) > 0, costs, as.character(NA))      

			# init positive
			pos = positive 
			neg = as.character(NA)
      levs = td["class.levels"]
			if (td["class.nr"] == 1) {
				if (is.na(pos)) {
					pos = levs[1]
				} else {
					if (!(pos %in% levs))
						stop(paste("Trying to set a positive class", pos, "which is not a value of the target variable:", paste(levs, collapse=",")))
				}
				neg = paste("not_", pos)
			} else if (td["class.nr"] == 2) {
				if (is.na(pos)) {
					pos = levs[1] 					
				}
				else {
					if (!(pos %in% levs))
						stop(paste("Trying to set a positive class", pos, "which is not a value of the target variable:", paste(levs, collapse=",")))
				}
				neg = setdiff(levs, pos)
			} else {
				if (!is.na(pos))
					stop("Cannot set a positive class for a multiclass problem!")
			}			
			td@positive = pos
      
			callNextMethod(.Object, data=data, weights=weights, blocking=blocking, control=control, task.desc=td)
		}
)


#' @rdname to.string
setMethod(
		f = "to.string",
		signature = signature("ClassifTask"),
		def = function(x) {
			di = paste(capture.output(x["class.dist"]), collapse="\n")
      rwm = sum(apply(x["data"], 1, function(x) any(is.na(x))))
      cwm = sum(apply(x["data"], 2, function(x) any(is.na(x))))
      rwi = sum(apply(x["data"], 1, function(x) any(is.infinite(x))))
      cwi = sum(apply(x["data"], 2, function(x) any(is.infinite(x))))
      feat = paste(capture.output(x["n.feat"]), collapse="\n")
			return(
					paste(
							"Classification problem ", x@desc@id, "\n",
							"Features:\n", feat, "\n", 
              "Observations: ", x["size"] , "\n",
              "Missings: ", x["has.missing"], "\n", 
              ifelse(x["has.missing"], paste("in", rwm, "observations and", cwm, "features\n"), ""), 
              "Infinites: ", x["has.inf"], "\n", 
              ifelse(x["has.inf"], paste("in", rwi, "observations and", cwi, "features\n"), ""),
              "Target: ", x["target"], "\n", 
              "Classes: ", x["class.nr"], "\n",
							di, "\n",
							ifelse(x["is.binary"], paste("Positive class:", x["positive"], "\n"), ""),
              "Has weights: ", x["has.weights"], "\n", 
              "Has blocking: ", x["has.blocking"], "\n",
              "Has costs: ", all(dim(x["costs"])!=0), "\n", 
              sep=""
					)
			)
		}
)

