#' @include learnerR.r
roxygen()
#' @include WrappedModel.R
roxygen()
#' @include train.learner.r
roxygen()
#' @include pred.learner.r
roxygen()
#' @include ClassifTask.R
roxygen()


setClass(
  "classif.mda", 
  contains = c("rlearner.classif")
)


setMethod(
  f = "initialize",
  signature = signature("classif.mda"),
  def = function(.Object) {
    
    desc = c(
      oneclass = FALSE,
      twoclass = TRUE,
      multiclass = TRUE,
      missings = FALSE,
      doubles = TRUE,
      factors = TRUE,
      decision = FALSE,
      prob = TRUE,
      weights = FALSE,
      costs = FALSE
    )
 
    x = callNextMethod(.Object, pack="mda", desc=desc)
    
    par.set = makeParameterSet(
      makeUntypedLearnerParameter(id="subclasses", default=2L),
      makeIntegerLearnerParameter(id="iter", default=5L, lower=1L),
      makeIntegerLearnerParameter(id="dimension", lower=1L),
      makeDiscreteLearnerParameter(id="method", default="polyreg", 
        vals=list(polyreg=polyreg, mars=mars, bruto=bruto, gen.ridge=gen.ridge)),
      makeLogicalLearnerParameter(id="trace", default=FALSE, flags=list(optimize=FALSE)),
      # change default and pass it to reduce mem
      makeLogicalLearnerParameter(id="keep.fitted", default=FALSE, flags=list(optimize=FALSE, pass.default=TRUE)),
      makeIntegerLearnerParameter(id="tries", default=5L, lower=1L)
    )

    x@par.set = par.set
    return(x)
  }
)

#' @rdname train.learner


setMethod(
  f = "train.learner",
  signature = signature(
    .learner="classif.mda", 
    .task="ClassifTask", .subset="integer" 
  ),
  
  def = function(.learner, .task, .subset,  ...) {
    f = .task["formula"]
    mda(f, data=get.data(.task, .subset), ...)
  }
)

#' @rdname pred.learner

setMethod(
  f = "pred.learner",
  signature = signature(
    .learner = "classif.mda", 
    .model = "WrappedModel", 
    .newdata = "data.frame", 
    .type = "character" 
  ),
  
  def = function(.learner, .model, .newdata, .type, ...) {
    .type <- ifelse(.type=="response", "class", "posterior")
    predict(.model["learner.model"], newdata=.newdata, type=.type, ...)
  }
)	




