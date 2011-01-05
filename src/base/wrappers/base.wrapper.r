#' @include learner.r
roxygen()
#' @include set.id.r
roxygen()
#' @include set.hyper.pars.r
roxygen()
#' @include set.predict.type.r
roxygen()
#' @include train.learner.r
roxygen()
#' @include pred.learner.r
roxygen()


#' Abstract base class to wrap something around a learner.
#' @exportClass base.wrapper

setClass(
		"base.wrapper",
		contains = c("learner"),
		representation = representation(
			learner = "learner"
		)
)


#' Constructor.

setMethod(
		f = "initialize",
		signature = signature("base.wrapper"),
		def = function(.Object, learner, par.descs, par.vals=list(), pack=as.character(c())) {
			if (missing(learner))
				return(make.empty(.Object))
			.Object@learner = learner
      w = callNextMethod(.Object, id=learner["id"], par.descs=par.descs, par.vals=par.vals, pack=pack)
      ns = intersect(names(w@par.descs), names(learner["par.descs"]))
      if (length(ns) > 0)
        stop("Hyperparameter names in wrapper clash with base learner names: ", paste(ns, collapse=","))
      return(w)
		}
)



#' @rdname base.wrapper-class

setMethod(
		f = "[",
		signature = signature("base.wrapper"),
		def = function(x,i,j,...,drop) {
      # these belong to base.wrapper and can be different from basic rlearner 
			if(i %in% c("id", "learner", "predict.type"))
				return(callNextMethod())
      
      if(i == "pack") {
				return(c(x@learner["pack"], x@pack))
			}			
			if(i == "par.descs") {
        return(c(x@learner["par.descs"], x@par.descs))
			}
      if(i == "par.vals") {
        return(c(x@learner["par.vals"], x@par.vals))
      }
      if(i == "par.train") {
        return(c(x@learner["par.train"], callNextMethod()))
      }
      if(i == "par.predict") {
        return(c(x@learner["par.predict"], callNextMethod()))
      }
      if(i == "leaf.learner") {
        y = x@learner 
        while (is(y, "base.wrapper")) 
          y = y@learner
        return(y)  
      }
      return(x@learner[i])
		}
)


#' @rdname train.learner
setMethod(
  f = "train.learner",
  signature = signature(
    .learner="base.wrapper", 
    .task="learn.task", .subset="integer"
  ),
  
  def = function(.learner, .task, .subset,  ...) {
    train.learner(.learner@learner, .task, .subset, ...)
  }
)

#' @rdname pred.learner
setMethod(
		f = "pred.learner",
		signature = signature(
				.learner = "base.wrapper", 
				.model = "wrapped.model", 
				.newdata = "data.frame", 
				.type = "ANY" 
		),
		
		def = function(.learner, .model, .newdata, .type, ...) {
			pred.learner(.learner@learner, .model, .newdata, .type, ...)
		}
)	

#' @rdname set.hyper.pars 
setMethod(
	f = "set.hyper.pars",
	
	signature = signature(
			learner="base.wrapper", 
			par.vals="list" 
	),
	
	def = function(learner, ..., par.vals=list()) {
		ns = names(par.vals)
		pds.n = names(learner["par.descs", par.top.wrapper.only=TRUE])
		for (i in seq(length=length(par.vals))) {
			if (ns[i] %in% pds.n) {
				learner = callNextMethod(learner, par.vals=par.vals[i])
			} else {	
				learner@learner = set.hyper.pars(learner@learner, par.vals=par.vals[i])
			}
		}
		return(learner)
	} 
)


#' @rdname to.string
setMethod(f = "to.string",
  signature = signature("base.wrapper"),
  def = function(x) {
    s = ""
    y = x 
    while (is(y, "base.wrapper")) {
      s = paste(s, class(y), "->", sep="")
      y = y@learner
    }
    s = paste(s, class(y))
    
    hps = x["par.vals"]
    hps.ns = names(hps)
    hps = Map(function(n, v) hyper.par.val.to.name(n,v,x), hps.ns, hps)
    hps = paste(hps.ns, hps, sep="=", collapse=" ")

    return(paste(
        s, "\n",
        "Hyperparameters: ", hps, "\n\n",
        sep = ""         
      ))
  })



