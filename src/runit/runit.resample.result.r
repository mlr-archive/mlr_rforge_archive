

test.resample.result = function() {
	rin1 <- make.bs.instance(size=nrow(testsuite.df), iters=4)
	rin2 <- make.cv.instance(size=nrow(testsuite.df), iters=7)
	rin3 <- make.subsample.instance(size=nrow(testsuite.df), iters=2)
	
	ct <- new("classif.task", new("lda"), data=testsuite.df, formula=testsuite.formula)
	
	result1 <- resample.fit(ct, rin1)       
	result2 <- resample.fit(ct, rin2)       
	result3 <- resample.fit(ct, rin3)       
	
	checkEquals(result1["iters"], 4)
	checkEquals(result2["iters"], 7)
	checkEquals(result3["iters"], 2)
	
	cc <- ct["target.col"]
	
#	for (i in 1:rin1["iters"]) {
#		checkEquals(rin1["train.inds", i], result1["train.inds", i])
#		checkEquals(rin1["test.inds", i], result1["test.inds", i])
#		checkEquals(result1["targets.train", i], testsuite.df[result1["train.inds", i], cc])
#		checkEquals(result1["targets.test", i], testsuite.df[result1["test.inds", i], cc])
#	}		
#		
#	for (i in 1:rin2["iters"]) {
#		checkEquals(rin2["train.inds", i], result2["train.inds", i])
#		checkEquals(rin2["test.inds", i],  result2["test.inds", i])
#		checkEquals(result2["targets.train", i], testsuite.df[result2["train.inds", i], cc])
#		checkEquals(result2["targets.test", i], testsuite.df[result2["test.inds", i], cc])
#	}		
#		
#	for (i in 1:rin3["iters"]) {
#		checkEquals(rin3["train.inds", i], result3["train.inds", i])
#		checkEquals(rin3["test.inds", i],  result3["test.inds", i])
#		checkEquals(result3["targets.train", i], testsuite.df[result3["train.inds", i], cc])
#		checkEquals(result3["targets.test", i], testsuite.df[result3["test.inds", i], cc])
#	}		
}



