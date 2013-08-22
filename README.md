# Temporal segmentation using one-class support vector machines

This Matlab project is used as an experimental setup for the master thesis of Roemer Vlasveld.

## One-Class Support Vector Machines?
I have written an [Introduction to One-Class Support Vector Machines](http://rvlasveld.github.io/blog/2013/07/12/introduction-to-one-class-support-vector-machines/) explaining the idea of One-Class SVM.
That should be a good starting point to understand this material.

## How to use this
I am planning to write a small how-to on this library, but currently it is under to much development to make that.
The function `apply_inc_svdd` is the main application.
There the incremental SVDD (by Tax and Duin) is constructed, from the data set.

## What libraries are used?
For the one-class support vector machine, the SVDD method by Tax and Duin is used.
This is provided by the [dd_tools](http://prlab.tudelft.nl/david-tax/dd_tools.html) package, which in turn relies on the [PRTools](http://prtools.org/software/) toolbox.
