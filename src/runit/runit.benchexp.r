test.benchexp <- function() {
	
	outer = make.res.desc("cv", iters=3)
	inner = make.res.desc("cv", iters=2)
	
	r = list(minsplit=seq(3,10,2))
	rpart.tuner = make.tune.wrapper("classif.rpart", resampling=inner, control=grid.control(ranges=r))
	learners = list("classif.lda", rpart.tuner)

	bench.exp("classif.lda", multiclass.task, resampling=outer)
	wl = make.learner("classif.lda")
	be = bench.exp(wl,  multiclass.task, resampling=outer)
	print(be)	
	be = bench.exp(rpart.tuner,  multiclass.task, resampling=outer)
	print(be)
	ms = list("acc", time="time", foo=function(x,task) 1)
	be = bench.exp(learners, multiclass.task, resampling=outer, measures=ms)
	print(be)	
	x = be["perf", learner=c("classif.lda", "classif.rpart")]
	checkTrue(is.list(x))
	checkEquals(length(x), 1)
	checkEquals(dim(x[[1]]), c(3, 2, 3))	
	x = be["perf", learner=c("classif.lda", "classif.rpart"), measure="acc"]
	checkEquals(length(x), 1)
	checkEquals(dim(x[[1]]), c(3, 2, 1))	
	
	be = bench.exp("regr.lm", regr.task, resampling=outer)
	print(be)
}