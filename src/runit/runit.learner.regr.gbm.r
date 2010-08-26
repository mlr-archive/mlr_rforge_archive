
test.gbm.regr <- function() {
  library(gbm)
	parset.list <- list(
			list(),
			list(n.trees=600),
			list(interaction.depth = 2)
	)
	
	
	old.predicts.list = list()
	
	for (i in 1:length(parset.list)) {
		parset <- parset.list[[i]]
		pars <- list(regr.formula, data=regr.train, distribution="gaussian")
		pars <- c(pars, parset)
		set.seed(debug.seed)
		capture.output(
			m <- do.call(gbm, pars)
		)
		set.seed(debug.seed)
		p <- predict(m, newdata=regr.test, n.trees=length(m$trees))
		old.predicts.list[[i]] <- p
	}
	
	simple.test.parsets("regr.gbm", regr.df, regr.target, regr.train.inds, old.predicts.list, parset.list)
}
