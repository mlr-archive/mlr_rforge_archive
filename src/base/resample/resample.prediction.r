#' @include task.learn.r
#' @include resample.instance.r
roxygen()

#' @exportClass resample.prediction

setClass(
		"resample.prediction",
		contains = c("prediction"),
		representation = representation(
				instance="resample.instance", 
				extracted="list"
		)
)

#' Constructor.

setMethod(
		f = "initialize",
		signature = signature("resample.prediction"),
		def = function(.Object, instance, preds, extracted) {
			p1 = preds[[1]]
			.Object@instance = instance
			.Object@extracted = extracted
			tt = sapply(preds, function(x) x["time.train"])
			tp = sapply(preds, function(x) x["time.predict"])
			df = Reduce(function(a,b) rbind(a, b@df), preds, init=data.frame())
			es = sapply(preds, function(x) nrow(x@df))
			df$iter = rep(1:length(preds), times=es)
			callNextMethod(.Object, p1@data.desc, p1@task.desc, df, tt, tp)
		}
)




#' @rdname to.string

setMethod(
		f = "to.string",
		signature = signature("resample.prediction"),
		def = function(x) {
			return(
					paste(
							"Resampling result for ", x@instance["name"], " with ", x["iters"], " iterations\n",
							#"Learner models were ", ifelse(length(x@models)==0,"not", ""), " saved\n\n",
							#paste(capture.output(str(x@preds)), collapse="\n"), 
							"\n", sep=""
					)
			)
		}
)

#' Getter
#' @rdname resample.prediction-class


setMethod(
		f = "[",
		signature = signature("resample.prediction"),
		def = function(x,i,j,...,drop) {
			if (i == "iters")
				return(x@instance["iters"])
			callNextMethod()
		}
)


setMethod(
		f = "as.list",
		signature = signature("resample.prediction"),
		def = function(x, all.names = FALSE, ...) {
			preds = list()
			df = x@df
			for (i in 1:x@instance["iters"]) {
				j = which(df$iter == i)
				preds[[i]] = new("prediction", task.desc=x@task.desc, data.desc=x@data.desc, df=df[j,], x@time.train[i], x@time.predict[i])
			}
			return(preds)
		}
)

