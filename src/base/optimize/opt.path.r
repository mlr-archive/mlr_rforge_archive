
#' Optimazation path. Optimizers log their evaluated points
#' iteratively into this object.
#' 
#' Can be converted to a list or data.frame.
#' 
#' @exportClass opt.path
#' @title Optimazation path
setClass(
  "opt.path",
  contains = c("object"),
  representation = representation(
    x.names = "character",
    y.names = "character",
    env = "environment"
  )
)

#' Constructor.
setMethod(
  f = "initialize",
  signature = signature("opt.path"),
  def = function(.Object, x.names, y.names) {
    if (length(intersect(x.names, y.names)) > 0)
      stop("x.names and y.names must be unique.")
    .Object@x.names = x.names
    .Object@y.names = y.names
    .Object@env$path = list()
    .Object@env$dob  = integer()
    .Object@env$eol  = integer()
    return(.Object)
  }
)

make.opt.path = function(bounds, y.names) {
  new("opt.path", sapply(bounds, function(p) p@id), y.names)
}

#' Convert to data.frame
#' @rdname opt.path-class 
#' @export
setMethod(
  f = "as.data.frame",
  signature = signature("opt.path"),
  def = function(x, row.names = NULL, optional = FALSE,...) {
    df <- do.call(rbind, lapply(x@env$path, function(e) cbind(as.data.frame(e$x),as.data.frame(t(e$y)))))
    df[[".dob"]] <- x@env$dob
    df[[".eol"]] <- x@env$eol
    df
  }
)

#' Convert an optimization path to a list.
#' @rdname opt.path-class
setMethod(
  f = "as.list",
  signature = signature("opt.path"),
  def = function(x, row.names = NULL, optional = FALSE,...) {
    l <- x@env$path
  }
)

##' @rdname to.string
setMethod(
  f = "to.string",
  signature = signature("opt.path"),
  def = function(x) {
    return(paste("Opt. path of length: ", length(as.list(x))))
  }
)

#' Add a new element to the optimiztion path.
#'
#' @param op Optimization path.
#' @param z List of parameter settings.
#' @param dob Date of birth of the new parameters. 
#' @param eol End of life of the parameters. Defaults to unknown (NA).
#' @return NULL. This function is called for its side effects, namely
#'   adding z to the optimization path.
add.path.el = function(op, x, y, dob=length(as.list(op)), eol=NA) {
  stopifnot(inherits(op, "opt.path"),          
            is.na(eol) || eol >= dob)
            
  op@env$path = append(op@env$path, list(list(x=x, y=y)))
  op@env$dob = append(op@env$dob, dob)
  op@env$eol = append(op@env$eol, eol)
  NULL
}

#' Convert a parameter list to its position in the optimiztion path.
#'
#' @param op Optimization path.
#' @param z List of parameter settings.
#' @param cand Expression limiting the path elements searched.
#' @return Index of \code{z} in optimization path or if \code{z} is
#'  not present \code{NA}.
param.to.position <- function(op, z, cand) {
  if (!missing(cand)) {
    r <- eval(eval(substitute(substitute(cand, op@env))), parent.frame())
    idx <- which(r)
    tmp <- Position(function(zz) identical(z, zz), op@env$path[idx])
    if (!is.na(tmp))
      idx[tmp]
    else
      tmp
  } else {
    Position(function(zz) identical(z, zz), op@env$path)
  }
}

#' Set the end of life of a parameter vector.
#'
#' @param op Optimization path.
#' @param z List of parameter settings.
#' @param endoflife End of life of parameter setting.
#' @return NULL, this function is called for its side effect, namely
#'   modifing the optimization path.
set.eol = function(op, z, endoflife=length(as.list(op))) {
  stopifnot(inherits(op, "opt.path"), endoflife == as.integer(endoflife))
  if (!is.integer(z))
    z <- param.to.position(op, z, is.na(eol) & dob <= endoflife)
  if (is.na(z))
    stop("No element found matching the given parameter settings. Cannot set EoL!")
  op@env$eol[z] <- as.integer(endoflife)
  NULL
} 

#' Get the date of birth or end of life a list parameter settings.
#'
#' @param op Optimization path.
#' @param z List of parameter settings.
#' @return The date of birth or end of life of \code{z}.
get.dob = function(op, z) {
  stopifnot(inherits(op, "opt.path"))
  if (!is.integer(z)) {
    z <- param.to.position(op, z)
    if (is.na(tmp))
      stop("No element found matching the given parameter settings. Cannot get DoB!")
  }
  op@env$dob[z]
}

#' @rdname get.dob
get.eol = function(op, z) {
  stopifnot(inherits(op, "opt.path"))
  if (!is.integer(z)) {
    z <- param.to.position(op, z)
    if (is.na(z))
      stop("No element found matching the given parameter settings. Cannot get EoL!")
  }
  op@env$eol[z]
}

