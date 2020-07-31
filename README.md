<!-- badges: start -->
[![Travis build status](https://travis-ci.org/beckerbenj/eatATA.svg?branch=master)](https://travis-ci.org/beckerbenj/eatATA)
[![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/beckerbenj/eatATA?branch=master&svg=true)](https://ci.appveyor.com/project/beckerbenj/eatATA)
[![Codecov test coverage](https://codecov.io/gh/beckerbenj/eatATA/branch/master/graph/badge.svg)](https://codecov.io/gh/beckerbenj/eatATA?branch=master)
<!-- badges: end -->


# eatATA

## Overview

`eatATA` provides a small `R` interface to mathematical optimization solvers specialized on solving simple automated test assembly problems (*ATA*). Internally, sparse matrices are used via the `Matrix` package. Currently the only supported solver  is `Gurobi`. See below for a list of implemented features and feature to come.

## Installation

```R
# Install eatATA from GitHub via
devtools::install_github("beckerbenj/eatATA", build_vignettes = TRUE)
```

## Documentation

```R
library(eatATA)
vignette("eatATA")
```

## Implemented Features

The following types of constraints can be set via `eatATA`:

* no item overlap between test forms

* complete item pool depletion

* categorical and numerical constraints across test forms

* excluding items from being together in the same booklet (item exclusions)

* simple optimization constraints

## Outlook

We are hoping to build interfaces to other mathematical optimization solvers. The current interface to `Gurobi` is the function `prepareConstraints()`. 

Constraints that we hope to implement in the future:

* force items to be in the same test form

* taking into account hierarchical stimulus-item structures

* more complex optimization targets

If you wish to contribute to the package, please send an email to b.becker@iqb.hu-berlin.de.


