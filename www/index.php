<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html>
<head>
	<title>Wrapped learners</title>
	<link rel="stylesheet" type="text/css" href="formats.css">
	<style type="text/css">
	</style>
</head>

<body>

<h1>The mlr Package: Machine Learning in R</h1>
	
<P>
Written by: Bernd Bischl, Max Wornowizki, Katharina Borg
<P>
Very much work in progess, planning to publish a first version soon.
<P>
Motivation:
There is no unifying mechanism for the many classification algorithms in R. Non-trivial experiments
force you to write lengthy, tedious and error-prone code. Although there are methods / packages which try to improve upon this, they often lack in other areas like extensibility.
<P>
<b>Features:</b>
<ul> 
	<li>Clear S4 interface to R classification methods</li>
	<li>Easy extension mechanism through S4 inheritance for new methods</li>
	<li>Resampling strategies like boostrapping, cross-validation and subsampling ("paired" - same splits for different algorithms - as the experiment setup is S4 object itself and can be reused)</li>
	<li>Tuning of hyperparamters</li>
	<li>Benchmarking of different algorithms (e.g. by double cross-validation with tuning on inner cross-validation)</li>
	<li>Use benchmark package for analysis and visualization</li>
	<li>Supports different parallelization frameworks in R (like snowfall)</li>
</ul>


<b>Outlook:</b>
<ul> 
	<li>Have a look at other visualization packages (e.g. rgobi, ROCR, classifly) and include useful plots</li>
	<li>Investigate and implement better tuning techniques than grid search</li>
	<li>GUI</li>
</ul>

<b>Installation:</b> 
<P>
	install.packages("mlr",repos="http://R-Forge.R-project.org")
</P>


<b>Project links:</b>
<ul> 
	<li><a href="http://r-forge.r-project.org/projects/mlr/">Project page</a> at R-Forge (bugtracker, mailing list, svn)</li>
	<li><a href="intro.html">Documentation</a> </li>
</ul>


</body>
</html>