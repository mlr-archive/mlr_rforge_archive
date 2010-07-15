make.ROCR.pred = function (predictions, labels, label.ordering = NULL) 
{
	if (is.data.frame(predictions)) {
		names(predictions) <- c()
		predictions <- as.list(predictions)
	}
	else if (is.matrix(predictions)) {
		predictions <- as.list(data.frame(predictions))
		names(predictions) <- c()
	}
	else if (is.vector(predictions) && !is.list(predictions)) {
		predictions <- list(predictions)
	}
	else if (!is.list(predictions)) {
		stop("Format of predictions is invalid.")
	}
	if (is.data.frame(labels)) {
		names(labels) <- c()
		labels <- as.list(labels)
	}
	else if (is.matrix(labels)) {
		labels <- as.list(data.frame(labels))
		names(labels) <- c()
	}
	else if ((is.vector(labels) || is.ordered(labels) || is.factor(labels)) && 
			!is.list(labels)) {
		labels <- list(labels)
	}
	else if (!is.list(labels)) {
		stop("Format of labels is invalid.")
	}
	if (length(predictions) != length(labels)) 
		stop(paste("Number of cross-validation runs must be equal", 
						"for predictions and labels."))
	if (!all(sapply(predictions, length) == sapply(labels, length))) 
		stop(paste("Number of predictions in each run must be equal", 
						"to the number of labels for each run."))
	for (i in 1:length(predictions)) {
		finite.bool <- is.finite(predictions[[i]])
		predictions[[i]] <- predictions[[i]][finite.bool]
		labels[[i]] <- labels[[i]][finite.bool]
	}
	label.format = ""
	if (all(sapply(labels, is.factor)) && !any(sapply(labels, 
					is.ordered))) {
		label.format <- "factor"
	}
	else if (all(sapply(labels, is.ordered))) {
		label.format <- "ordered"
	}
	else if (all(sapply(labels, is.character)) || all(sapply(labels, 
					is.numeric)) || all(sapply(labels, is.logical))) {
		label.format <- "normal"
	}
	else {
		stop(paste("Inconsistent label data type across different", 
						"cross-validation runs."))
	}
	if (!all(sapply(labels, levels) == levels(labels[[1]]))) {
		stop(paste("Inconsistent factor levels across different", 
						"cross-validation runs."))
	}
	levels <- c()
	if (label.format == "ordered") {
		if (!is.null(label.ordering)) {
			stop(paste("'labels' is already ordered. No additional", 
							"'label.ordering' must be supplied."))
		}
		else {
			levels <- levels(labels[[1]])
		}
	}
	else {
		if (is.null(label.ordering)) {
			if (label.format == "factor") 
				levels <- sort(levels(labels[[1]]))
			else levels <- sort(unique(unlist(labels)))
		}
		else {
			if (!setequal(unique(unlist(labels)), label.ordering)) {
				stop("Label ordering does not match class labels.")
			}
			levels <- label.ordering
		}
		for (i in 1:length(labels)) {
			if (is.factor(labels)) 
				labels[[i]] <- ordered(as.character(labels[[i]]), 
						levels = levels)
			else labels[[i]] <- ordered(labels[[i]], levels = levels)
		}
	}
	if (length(levels) != 2) {
		message <- paste("Number of classes is not equal to 2.\n", 
				"ROCR currently supports only evaluation of ", "binary classification tasks.", 
				sep = "")
		stop(message)
	}
	if (!is.numeric(unlist(predictions))) {
		stop("Currently, only continuous predictions are supported by ROCR.")
	}
	cutoffs <- list()
	fp <- list()
	tp <- list()
	fn <- list()
	tn <- list()
	n.pos <- list()
	n.neg <- list()
	n.pos.pred <- list()
	n.neg.pred <- list()
	for (i in 1:length(predictions)) {
		n.pos <- c(n.pos, sum(labels[[i]] == levels[2]))
		n.neg <- c(n.neg, sum(labels[[i]] == levels[1]))
		ans <- ROCR:::.compute.unnormalized.roc.curve(predictions[[i]], 
				labels[[i]])
		cutoffs <- c(cutoffs, list(ans$cutoffs))
		fp <- c(fp, list(ans$fp))
		tp <- c(tp, list(ans$tp))
		fn <- c(fn, list(n.pos[[i]] - tp[[i]]))
		tn <- c(tn, list(n.neg[[i]] - fp[[i]]))
		n.pos.pred <- c(n.pos.pred, list(tp[[i]] + fp[[i]]))
		n.neg.pred <- c(n.neg.pred, list(tn[[i]] + fn[[i]]))
	}
	nsp = getNamespace("ROCR")
	cl = getClass("prediction", where=nsp)
	.Object = new(cl)
	.Object@predictions = predictions			
	.Object@labels = labels			
	.Object@cutoffs = cutoffs
	.Object@fp = fp			
	.Object@tp = tp			
	.Object@tn = tn			
	.Object@fn = fn			
	.Object@n.pos = n.pos			
	.Object@n.neg = n.neg		
	.Object@n.pos.pred = n.pos.pred			
	.Object@n.neg.pred = n.neg.pred		
	return(.Object)		
	
}