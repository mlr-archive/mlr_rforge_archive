
test.svm <- function() {
  library(e1071)
	set.seed(debug.seed)
	m <- ksvm(x=multiclass.formula, data=multiclass.train, kernel="rbfdot", kpar=list(sigma=20), prob.model = T)
	p <-  predict(m, newdata=multiclass.test)
	p2 <- predict(m, newdata=multiclass.test, type="prob")
	simple.test("classif.ksvm", multiclass.df, multiclass.target, multiclass.train.inds, p,  parset=list(sigma=20))
	prob.test  ("classif.ksvm", multiclass.df, multiclass.target, multiclass.train.inds, p2, parset=list(sigma=20))
	
	set.seed(debug.seed)
	m <- ksvm(x=multiclass.formula, data=multiclass.train, kernel="laplacedot", kpar=list(sigma=10), prob.model = T)
	p <- predict(m, newdata=multiclass.test)
	p2 <- predict(m, newdata=multiclass.test, type="prob")
	simple.test("classif.ksvm",multiclass.df, multiclass.target, multiclass.train.inds, p,  parset=list(kernel="laplacedot", sigma=10))
	prob.test  ("classif.ksvm",multiclass.df, multiclass.target, multiclass.train.inds, p2, parset=list(kernel="laplacedot", sigma=10))
	
	set.seed(debug.seed)
	m <- ksvm(x=multiclass.formula, data=multiclass.train, kernel="polydot", kpar=list(degree=3, offset=2, scale=1.5), prob.model = T)
	p <- predict(m, newdata=multiclass.test)
	p2 <- predict(m, newdata=multiclass.test, type="prob")
	simple.test("classif.ksvm", multiclass.df, multiclass.target, multiclass.train.inds, p,  parset=list(kernel="polydot", degree=3, offset=2, scale=1.5))
	prob.test  ("classif.ksvm", multiclass.df, multiclass.target, multiclass.train.inds, p2, parset=list(kernel="polydot", degree=3, offset=2, scale=1.5))
	
	tt <- function (formula, data, subset=1:150, ...) {
		ksvm(x=formula, data=data[subset,], kernel="polydot", kpar=list(degree=3, offset=2, scale=1.5))
	}
	
	cv.test("classif.ksvm", multiclass.df, multiclass.target, tune.train=tt, parset=list(kernel="polydot", degree=3, offset=2, scale=1.5))
	
}
