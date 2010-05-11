
eval.parsets = function(learner, task, resampling, type, measures, aggr, control, pars) {
	rps = mylapply(xs=pars, from="tune", f=eval.rf, learner=learner, task=task, resampling=resampling, 
			type=type, measures=measures, aggr=aggr, control=control)
	return(rps)
}

# evals a set of var-lists and return the corresponding states
eval.states.tune = function(learner, task, resampling, type, measures, aggr, control, pars, event) {
	eval.states(".mlr.tuneeval", eval.fun=eval.parsets, 
			learner=learner, task=task, resampling=resampling, type=type, 
			measures=measures, aggr=aggr, control=control, pars=pars, event=event)
}


add.path.els.tune = function(path, ess, best) {
	add.path.els(".mlr.tuneeval", path, ess, best)	
} 

