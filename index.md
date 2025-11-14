# eatATA

# eatATA

## Overview

`eatATA` provides a small `R` interface to mathematical optimization
solvers specialized on solving simple automated test assembly problems
(`ATA`). Internally, sparse matrices are used via the `Matrix` package.
Currently supported solvers are `GLPK`, `lpSolve`, `Symphony`, and
`Gurobi`. See below for a list of implemented features and feature to
come.

## Installation

``` r
# Install eatATA from CRAN via
install.packages("eatATA")

# Install development version from GitHub via
remotes::install_github("beckerbenj/eatATA", build_vignettes = TRUE, dependencies = TRUE)
```

## Documentation

An extensive tutorial paper including a variety of use cases has been
published here: <https://doi.org/10.3390/psych3020010>. Additionally, a
set of vignettes describing the current functionality can be found on
[CRAN](https://CRAN.R-project.org/package=eatATA/).

## Implemented Features

`eatATA` is suitable for the automated test assembly of fixed linear
test forms or multi-stage testing modules. For example, the following
types of constraints can be set via `eatATA`:

- no item overlap between test forms

- complete item pool depletion

- categorical and numerical constraints across test forms

- excluding items from being together in the same booklet (item
  exclusions)

- force items to be in the same test form (item inclusions)

- force a set of items to be included in the test forms

- various optimization constraints

## Outlook

Features that might be implemented in the future:

- taking into account hierarchical stimulus-item structures

- adopting the `ROI` framework to access a larger number of solvers

If you wish to contribute to the package, please send an email to
<b.becker@iqb.hu-berlin.de>.
