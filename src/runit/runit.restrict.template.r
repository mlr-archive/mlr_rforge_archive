
test.restrict.learn.task = function() {
	
	ct <- make.task(data=multiclass.df, target=multiclass.target)
	
	inds2 = c(1,7,10)
	inds3 = c(1,1,7,11,11)
	
	ct2 <- restrict.learn.task(ct, inds2)
	ct3 <- restrict.learn.task(ct, inds3)
	
	checkEquals(multiclass.df[inds2,], ct2["data"])
	checkEquals(multiclass.df[inds3,], ct3["data"])
}
