# eatATA 1.1.2

* internal testing fix (non-deterministic optimization problem with deterministic tests)


# eatATA 1.1.1

* internal testing fix


# eatATA 1.1.0

* `getMean2PLN()` and `getMean2PLN()` for calculating the mean of the two- 
and three-parameter log-normal response time distributions, based on a set of 
parameters.
* `getMar2PLN()` and `getVar2PLN()` for calculating the variance of the two- 
and three-parameter log-normal response time distributions, based on a set of 
parameters
* bug fix in `inspectSolution()` (works with `tibbles` now)
* bug fix in `itemValuesConstraint()` (works with negative `itemValues` now)
* bug fix in `itemTuples()` (#1)

# eatATA 1.0.0

* updated overview vignette
* added mathematical formulations of implementation on the help page of `itemValuesConstraint()`
* added `acrossFormsConstraint()` for constraints across test forms
* more rigorous input checks for all constraint functions


# eatATA 0.11.2

* fix occasional system dependent test failure


# eatATA 0.11.1

* fix `non ascii` character in help file


# eatATA 0.11.0

* constraint functions re-named consistently (now ending all on `Constraint`) 
* objective function functions re-named consistently (now ending all on `Objective`) 
* `itemUsageConstraint()` argument `whichItem` now takes a character vector (item identifiers) as input
* `itemInclusionConstraint()` added to force items to be in the same test forms
* `stemInclusionTuples()` added to create inclusion tuples from column with shared stimulus
* `itemExclusionTuples()` renamed to `itemTuples()`, as it can also be used for `itemInclusionConstraint()`
* argument names in `itemTuples()` and `itemExclusionConstraint()` slightly modified
* added simulated item pools for examples
* renamed all item pools consistently (`items_mini`, `items_diao`, `items_pilot`, `items_vera`, `items_lsa`)


# eatATA 0.10.0

* argument `nItems` either completely removed from constraint functions or exchangeable with `itemIDs` 
* `itemTargetConstraint()` substituted by `minimaxConstraint()`, `maximinConstraint()`, `maxConstraint()`, `minConstraint()`, `cappedMaximinConstraint()` which allow for different types of optimization goals
* `Symphony` added as available solver (via `Rsymphony`)
* `inspectSolution()` now allows character variables in the input if sums are calculated
* `autoItemValuesMinMax()` now works for different test length via `testLength` argument

## Documentation

* reworked use case vignette
* added minimal example vignette
* added vignette with package overview

## Internal Changes

* input checks (feasible solution?) for `analyzeBlockExclusion()` and `analyzeComplexBlockExclusion()`
* uniqueness of argument `itemID` is checked
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
