#todo: what if rev numbers change only because of update of other package?

writeMlrDesc <- function(desc.path, rev.nr) {
	sink(file=desc.path)
	cat(
		"Package: mlr\n",
		"Type: Package\n",
		"Title: mlr: Machine Learning in R\n",
		paste("Version: 0.3.", rev.nr, "\n", sep=""),
		"Date: 2009-01-01\n",
		"Author: Bernd Bischl, Max Wornowizki, Katharina Borg\n",
		"Maintainer: Bernd Bischl <bernd_bischl@gmx.net>\n",
		"Description: no\n",
		"License: GPL (>= 2)\n",
		"LazyLoad: yes\n",
		"Depends: R (>= 2.8.0), methods, reshape, abind, boot, klaR, e1071, digest\n",
		"Suggests: MASS, snowfall, multicore, Rmpi, mlbench, cmaes, FSelector, kernlab, rpart, randomForest, adabag, kknn, ada, adabag, party, mboost, mda, gbm, nnet, penalized, RWeka, grplasso, earth, sda, DiceKriging, pls, foreign, gplots, rsm, penalizedSVM\n",
		sep=""
	)
	sink(NULL)
}

writeMlrEDADesc <- function(desc.path, rev.nr) {
  sink(file=desc.path)
  cat(
    "Package: mlrEDA\n",
    "Type: Package\n",
    "Title: mlr: Exploratory Data Analysis\n",
    paste("Version: 0.1.", rev.nr, "\n", sep=""),
    "Date: 2009-01-01\n",
    "Author: Bernd Bischl\n",
    "Maintainer: Bernd Bischl <bernd_bischl@gmx.net>\n",
    "Description: no\n",
    "License: GPL (>= 2)\n",
    "LazyLoad: yes\n",
    "Depends: R (>= 2.8.0), mlr, cluster, ggplot2, gridExtra\n",
    sep=""
  )
  sink(NULL)
}