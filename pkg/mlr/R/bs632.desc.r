#' @include resample.desc.r
roxygen()

setClass("bs632.desc", 
		contains = c("resample.desc.nonseq")
)                                                     


setMethod(
		f = "initialize",
		signature = signature("bs632.desc"),
		def = function(.Object, iters, reps) {
			aggr.group = function(x, g, rin) {
				i1 = which(g == "train")
				i2 = which(g == "test")
				0.368*x[i1,,drop=FALSE] + 0.632*x[i2,,drop=FALSE]
			}
			callNextMethod(.Object, "bs632.instance", "B632", iters, has.groups=TRUE, aggr.group=aggr.group)
		}
)


