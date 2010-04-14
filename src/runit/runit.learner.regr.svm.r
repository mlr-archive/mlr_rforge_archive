
test.svm.regr <- function() {
	
	parset.list <- list(
			list(),
			list(C = 0.3, kpar=list(sigma=2)),
			list(C = 0.3, kpar=list(sigma=2), epsilon=0.3)
	)
	
	old.predicts.list = list()
	
	for (i in 1:length(parset.list)) {
		parset <- parset.list[[i]]
		pars <- list(regr.formula, data=regr.train)
		pars <- c(pars, parset)
		set.seed(debug.seed)
		m <- do.call(ksvm, pars)
		p <- predict(m, newdata=regr.test)
		old.predicts.list[[i]] <- p[,1]
	}
	simple.test.parsets("regr.ksvm", regr.df, regr.formula, regr.train.inds, old.predicts.list, parset.list)
	

}