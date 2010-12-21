test.data.desc <- function() {
	checkEquals(multiclass.task["size"], 150)	
	checkEquals(multiclass.task["dim"], 4)	
	checkEquals(multiclass.task["exclude"], character(0))	
	checkEquals(multiclass.task["n.num"], 4)	
	checkEquals(multiclass.task["n.int"], 0)	
	checkEquals(multiclass.task["n.fact"], 0)	
	checkEquals(multiclass.task["has.missing"], F)	
	checkEquals(multiclass.task["is.classif"], T)	
	checkEquals(multiclass.task["is.regr"], F)	
	checkEquals(multiclass.task["class.levels"], c("setosa", "versicolor", "virginica"))	
	checkEquals(multiclass.task["class.nr"], 3)	
	checkEquals(multiclass.task["class.dist"], c(setosa=50, versicolor=50, virginica=50))	
	checkEquals(multiclass.task["is.binary"], F)
	
	# check missing values
	df = multiclass.df
	df[1,1] = as.numeric(NA)
	ct = make.task(target="Species", data=df)
	checkEquals(ct["has.missing"], T)	
	
	ct = make.task(target=binaryclass.target, data=binaryclass.df, exclude="V1")
	checkEquals(ct["size"], 208)	
	checkEquals(ct["dim"], 59)	
	checkEquals(ct["exclude"], "V1")	
	checkEquals(ct["n.num"], 59)	
	checkEquals(ct["n.int"], 0)	
	checkEquals(ct["n.fact"], 0)	
	checkEquals(ct["has.missing"], F)	
	checkEquals(ct["is.classif"], T)	
	checkEquals(ct["is.regr"], F)	
	checkEquals(ct["class.levels"], c("M", "R"))	
	checkEquals(ct["class.nr"], 2)	
	checkEquals(ct["class.dist"], c(M=111, R=97))	
	checkEquals(ct["is.binary"], T)	
	
	checkEquals(regr.task["size"], 506)	
	checkEquals(regr.task["dim"], 13)	
	checkEquals(regr.task["exclude"], character(0))	
	checkEquals(regr.task["n.num"], 12)	
	checkEquals(regr.task["n.int"], 0)	
	checkEquals(regr.task["n.fact"], 1)	
	checkEquals(regr.task["has.missing"], F)	
	checkEquals(regr.task["is.classif"], F)	
	checkEquals(regr.task["is.regr"], T)	
	checkTrue(is.na(regr.task["class.levels"]))	
	checkTrue(is.na(regr.task["class.nr"]))	
	checkTrue(is.na(regr.task["class.dist"]))	
	checkTrue(is.na(regr.task["is.binary"]))	
}