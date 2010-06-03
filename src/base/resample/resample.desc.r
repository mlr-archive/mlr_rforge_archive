#' Base class for description of resampling algorithms.
#' A description of a resampling algorithm contains all necessary information to provide a resampling.instance, 
#' when given the size of the data set.

#' @exportClass resample.desc 
#' @title resample.desc

# todo validation for size
setClass(
		"resample.desc", 
		contains = c("object"),
		representation = representation(
				instance.class="character", 
				name="character", 
				iters="numeric"
		)
)


#----------------- getter ---------------------------------------------------------

#' Getter.
#' 
#' \describe{
#' 	\item{instance.class [character]}{S4 class name of the corresponding resample.instance}
#' 	\item{name [character]}{Name of this resampling algorithm}
#' 	\item{iters [numeric]}{Number of iterations}
#' } 
#' 
#' @rdname resample.desc-class

setMethod(f="[",
          signature = signature("resample.desc"),
          def = function(x,i,j,...,drop) {
            if (i %in% slotNames(x))
              return(slot(x, i))
            return(NULL)            
          })

#' @rdname to.string

setMethod(
		f = "to.string",
		signature = signature("resample.desc"),
		def = function(x) {
			return(
					paste(
							"Description for ", x@name,  " with ", x@iters, " iterations.\n",
							sep=""
					)
			)
		}
)






