<!-- badges: start -->
[![CRAN status](https://www.r-pkg.org/badges/version/eatATA)](https://CRAN.R-project.org/package=eatATA)
[![R-CMD-check](https://github.com/beckerbenj/eatATA/workflows/R-CMD-check/badge.svg)](https://github.com/beckerbenj/eatATA/actions)
[![Codecov test coverage](https://codecov.io/gh/beckerbenj/eatATA/branch/master/graph/badge.svg)](https://codecov.io/gh/beckerbenj/eatATA?branch=master)
[![](http://cranlogs.r-pkg.org/badges/grand-total/eatATA?color=blue)](https://cran.r-project.org/package=eatATA)
<!-- badges: end -->


# eatATA

## Overview

`eatATA` provides a small `R` interface to mathematical optimization solvers specialized on solving simple automated test assembly problems (`ATA`). Internally, sparse matrices are used via the `Matrix` package. Currently supported solvers are `GLPK`, `lpSolve`, and `Gurobi`. See below for a list of implemented features and feature to come.

## Installation

```R
# Install eatATA from CRAN via
install.packages("eatATA")

# Install development version from GitHub via
remotes::install_github("beckerbenj/eatATA", build_vignettes = TRUE)
```

## Documentation

A vignette describing the current functionality can be found on [CRAN](https://CRAN.R-project.org/package=eatATA/vignettes/eatATA.html).

Alternatively, the vignette of the development version can be accessed through `R`. 

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

We are hoping to add interfaces to other mathematical optimization solvers. 

Constraints that we hope to implement in the future:

* force items to be in the same test form

* taking into account hierarchical stimulus-item structures

* more complex optimization targets

If you wish to contribute to the package, please send an email to b.becker@iqb.hu-berlin.de.


