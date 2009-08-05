#' @include wrapped.learner.regr.r 
roxygen()

#' @export
setClass(
		"myknn.regr", 
		contains = c("wrapped.learner.regr")
)


#----------------- train.kknn.model ---------------------------------------------------------

train.myknn <- function(formula, data, k=1, fun=mean) {
	list(formula=formula, data=data, k=k, fun=fun)
}

predict.myknn <- function(model, newdata) {
	k = model$k
	mf.train <- model.frame(model$formula, data=model$data) 
	mm.train <- model.matrix(model$formula, data=mf.train) 
	y <- esponse(mf.train)
	mm.test <- model.matrix(terms(model$formula, data=newdata), data=newdata) 
	nns <- ann(mm.train, mm.test, k=k)$knnIndexDist[,1:k, drop=FALSE]
	p <- apply(nns, 1, function(x) model$fun(y[x]) ) 
	
}


#----------------- constructor ---------------------------------------------------------

setMethod(
		f = "initialize",
		signature = signature("myknn.regr"),
		def = function(.Object, data, formula, train.fct.pars=list(), predict.fct.pars=list()) {
			train.fct <- train.myknn 
			predict.fct <- predict.myknn
			
			desc = new("method.desc",
					supports.missing = TRUE,
					supports.numerics = TRUE,
					supports.factors = TRUE,
					supports.characters = TRUE,
					supports.weights = FALSE
			)
			
			.Object <- callNextMethod(.Object, learner.name="myknn", learner.pack="yaImpute",
					learner.model.class="myknn", learner.model.S4 = FALSE,
					train.fct=train.fct, train.fct.pars=train.fct.pars,
					predict.fct=predict.fct, predict.fct.pars=predict.fct.pars,
					desc, data = data, formula=formula)
			return(.Object)
		}
)



