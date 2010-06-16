test.glmboost.classif <- function(){
	
	parset.list1 = list(
			list(family=Binomial(), control=boost_control(nu=0.03)),
			list(family=Binomial(), control=boost_control(mstop=600), center=T)
	)
	
	parset.list2 = list(
			list(family=Binomial(), nu=0.03),
			list(family=Binomial(), mstop=600, center=T)
	)
	
	old.predicts.list = list()
	old.probs.list = list()
	
	for (i in 1:length(parset.list1)) {
		parset = parset.list1[[i]]
		pars = list(binaryclass.formula, data=binaryclass.train)
		pars = c(pars, parset)
		set.seed(debug.seed)
		m = do.call(glmboost, pars)
		set.seed(debug.seed)
		old.predicts.list[[i]] = predict(m, newdata=binaryclass.test, type="class")
		set.seed(debug.seed)
		old.probs.list[[i]] = predict(m, newdata=binaryclass.test, type="response")[,1]
	}
	
	simple.test.parsets("classif.glmboost", binaryclass.df, binaryclass.target, binaryclass.train.inds, old.predicts.list, parset.list2)
	prob.test.parsets("classif.glmboost", binaryclass.df, binaryclass.target, binaryclass.train.inds, old.probs.list, parset.list2)
	
}


