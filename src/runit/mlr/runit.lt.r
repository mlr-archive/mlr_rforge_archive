test.mlr.learn.task <- function() {
	
	ct1 <- multiclass.task
	
	checkEquals(ct1@desc@target, "Species")
	checkEquals(getTargets(ct1), multiclass.df[,multiclass.target])
	
	ct = binaryclass.task
	pn = c(ct@desc@positive, ct@desc@negative)
	checkEquals(sort(ct@desc@class.levels), sort(pn))
	
  ct2 = subsetData(ct, subset=1:150)
  checkEquals(ct@desc@positive, ct2@desc@positive)
  
	# wrong vars
	checkException(subsetData(multiclass.task, vars=c("Sepal.Length", "x", "y")))
	
	# check missing accessors
	df = multiclass.df
	df[1,1:3] = NA
	df[2,1:3] = NA
	ct = makeClassifTask(data=df, target=multiclass.target)	
	checkTrue(ct["has.missing"])
}
