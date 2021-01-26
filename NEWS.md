# eatATA 0.9.1.9000

* `itemTargetConstraint()` substituted by `minimaxConstraint()`, `maximinConstraint()`, `maxConstraint()`, `minConstraint()`, `cappedMaximinConstraint()` which allow for different types of optimization goals
* `Symphony` added as available solver (via `Rsymphony`)
* `inspectSolution()` now allows character variables in the input if sums are calculated

## Documentation

* minimal example vignette
* vignette with package overview

## Internal Changes

* introduction of `constraint`-class with specific methods and constructor functions

# eatATA 0.9.1

* `GLPK` and `lpSolve` solvers are now supported
* `useSolver()` function implemented, which calls solver APIs directly
* `inspectSolution()` and `appendSolution()` functions, which use `useSovler()` output
* `prepareConstraints()` and `processGurobiOutput()` retired
* `calculateIIF()` calculates item information function
* `calculateExpectedRT()` calculates expected response times

# eatATA 0.7.0

* Initial CRAN release.
