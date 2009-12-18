test.tune <- function() {
	
	
	data <- multiclass.df
	formula <- multiclass.formula
	cp <- c(0.05, 0.9)
	minsplit <- c(1:3)
	ranges <- list(cp = cp, minsplit=minsplit)
	folds = 3
	
	tr <- tune.rpart(formula=formula, data=data, cp=cp, minsplit=minsplit,
			tunecontrol = tune.control(sampling = "cross", cross = folds))  
	
	cv.instance <- e1071.cv.to.mlr.cv(tr)
	
	ct <- make.classif.task(data=data, formula=formula)
	tr2 <- tune("rpart.classif", ct, cv.instance, method="grid", control=grid.control(ranges=ranges))
	
	for(i in 1:nrow(tr$performances)) {
		cp <- tr$performances[i,"cp"]
		ms <- tr$performances[i,"minsplit"]
		j <- which(tr2$all.perfs$cp == cp & tr2$all.perfs$minsplit == ms )
		checkEqualsNumeric(tr$performances[i,"error"], tr2$all.perfs[j,"mean"])    
		checkEqualsNumeric(tr$performances[i,"dispersion"], tr2$all.perfs[j,"sd"])    
	}
	
	# check pattern search
	control = ps.control(start=list(C=0, sigma=0))
	tr3 <- tune("kernlab.svm.classif", ct, cv.instance, method="pattern", control=control, scale=function(x)10^x)
	print(tr3)
	
#  rpart.learn.task <- new("t.rpart", data=data, formula=formula)
#  rpart.tuned <- tune.cv(rpart.learn.task, cv.instance, ranges)
	
#  attr(rpart.tuned$best.parameters,"out.attrs")<- NULL tr2                        Max: reicht das zur Überprüfung?
#  checkEquals(rpart.tuned$best.parameters, rev(trp$best.parameters))           Wie kann man hier verallgemeinern/Problem beheben?
}

