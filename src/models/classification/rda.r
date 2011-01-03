#' @include learnerR.r
roxygen()
#' @include wrapped.model.r
roxygen()
#' @include train.learner.r
roxygen()
#' @include pred.learner.r
roxygen()

setClass(
		"classif.rda", 
		contains = c("rlearner.classif")
)


setMethod(
		f = "initialize",
		signature = signature("classif.rda"),
		def = function(.Object) {
			
			desc = c(
					oneclass = FALSE,
					twoclass = TRUE,
					multiclass = TRUE,
					missings = FALSE,
					doubles = TRUE,
					factors = TRUE,
					prob = TRUE,
					decision = FALSE,
					weights = FALSE,			
					costs = FALSE
			)
			par.descs = list(
					new("par.desc.num", par.name="lambda", default="missing", lower=0, upper=1),
					new("par.desc.num", par.name="gamma ", default="missing", lower=0, upper=1),
					new("par.desc.log", par.name="crossval", default=TRUE),
					new("par.desc.num", par.name="fold", default=10L, lower=1L),
					new("par.desc.num", par.name="train.fraction", default=0.5, lower=0, upper=1),
					new("par.desc.log", par.name="crossval", default=TRUE),
					new("par.desc.disc", par.name="schedule", default=1L, vals=1:2, requires=expression(simAnn==FALSE)),
					new("par.desc.num", par.name="T.start", default=0.1, lower=0, requires=expression(simAnn==TRUE)),
					new("par.desc.num", par.name="halflife", default=0.1, lower=0, requires=expression(simAnn==TRUE || schedule==1)),
					new("par.desc.num", par.name="zero.temp", default=0.01, lower=0, requires=expression(simAnn==TRUE || schedule==1)),
					new("par.desc.num", par.name="alpha", default=2, lower=1, requires=expression(simAnn==TRUE || schedule==2)),
					new("par.desc.num", par.name="K", default=100L, lower=1L, requires=expression(simAnn==TRUE || schedule==2)),
					new("par.desc.disc", par.name="kernel", default="triangular", 
							vals=list("rectangular", "triangular", "epanechnikov", "biweight", "triweight", "cos", "inv", "gaussian")),
          new("par.desc.log", par.name="trafo", default=TRUE),
          new("par.desc.log", par.name="SimAnn", default=FALSE),
          # change default, so error is only estimated at request of user
          new("par.desc.log", par.name="estimate.error", default=FALSE, flags=list(optimize=FALSE, pass.default=TRUE))
			)
			
			callNextMethod(.Object, pack="klaR", desc=desc, par.descs=par.descs)
		}
)

#' @rdname train.learner

setMethod(
		f = "train.learner",
		signature = signature(
				.learner="classif.rda", 
				.task="classif.task", .subset="integer", .vars="character" 
		),
    # todo: disable crossval. no, is done automaticall if pars are set.
		def = function(.learner, .task, .subset, .vars,  ...) {
			f = .task["formula"]
			rda(f, data=.task["data"][.subset, .vars], ...)
		}
)

#' @rdname pred.learner

setMethod(
		f = "pred.learner",
		signature = signature(
				.learner = "classif.rda", 
				.model = "wrapped.model", 
				.newdata = "data.frame", 
				.type = "character" 
		),
		
		def = function(.learner, .model, .newdata, .type, ...) {
			p <- predict(.model["learner.model"], newdata=.newdata, ...)
			if (.type=="response")
				return(p$class)
			else
				return(p$posterior)
			
		}
)	
