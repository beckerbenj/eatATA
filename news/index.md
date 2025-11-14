# Changelog

## eatATA 1.1.2.9000

- [`itemExclusionConstraint()`](https://beckerbenj.github.io/eatATA/reference/itemExclusionConstraint.md):
  Fix bug with one-row matrix input
  ([\#6](https://github.com/beckerbenj/eatATA/issues/6))
- documentation fixes

## eatATA 1.1.2

CRAN release: 2023-12-12

- internal testing fix (non-deterministic optimization problem with
  deterministic tests)

## eatATA 1.1.1

CRAN release: 2022-11-28

- internal testing fix

## eatATA 1.1.0

CRAN release: 2022-09-26

- [`getMean2PLN()`](https://beckerbenj.github.io/eatATA/reference/getMean3PLN.md)
  and
  [`getMean2PLN()`](https://beckerbenj.github.io/eatATA/reference/getMean3PLN.md)
  for calculating the mean of the two- and three-parameter log-normal
  response time distributions, based on a set of parameters.
- `getMar2PLN()` and
  [`getVar2PLN()`](https://beckerbenj.github.io/eatATA/reference/getMean3PLN.md)
  for calculating the variance of the two- and three-parameter
  log-normal response time distributions, based on a set of parameters
- bug fix in
  [`inspectSolution()`](https://beckerbenj.github.io/eatATA/reference/inspectSolution.md)
  (works with `tibbles` now)
- bug fix in
  [`itemValuesConstraint()`](https://beckerbenj.github.io/eatATA/reference/itemValuesConstraint.md)
  (works with negative `itemValues` now)
- bug fix in
  [`itemTuples()`](https://beckerbenj.github.io/eatATA/reference/itemTuples.md)
  ([\#1](https://github.com/beckerbenj/eatATA/issues/1))

## eatATA 1.0.0

CRAN release: 2021-07-06

- updated overview vignette
- added mathematical formulations of implementation on the help page of
  [`itemValuesConstraint()`](https://beckerbenj.github.io/eatATA/reference/itemValuesConstraint.md)
- added
  [`acrossFormsConstraint()`](https://beckerbenj.github.io/eatATA/reference/acrossFormsConstraint.md)
  for constraints across test forms
- more rigorous input checks for all constraint functions

## eatATA 0.11.2

CRAN release: 2021-05-02

- fix occasional system dependent test failure

## eatATA 0.11.1

CRAN release: 2021-04-16

- fix `non ascii` character in help file

## eatATA 0.11.0

- constraint functions re-named consistently (now ending all on
  `Constraint`)
- objective function functions re-named consistently (now ending all on
  `Objective`)
- [`itemUsageConstraint()`](https://beckerbenj.github.io/eatATA/reference/itemUsageConstraint.md)
  argument `whichItem` now takes a character vector (item identifiers)
  as input
- [`itemInclusionConstraint()`](https://beckerbenj.github.io/eatATA/reference/itemExclusionConstraint.md)
  added to force items to be in the same test forms
- [`stemInclusionTuples()`](https://beckerbenj.github.io/eatATA/reference/stemInclusionTuples.md)
  added to create inclusion tuples from column with shared stimulus
- `itemExclusionTuples()` renamed to
  [`itemTuples()`](https://beckerbenj.github.io/eatATA/reference/itemTuples.md),
  as it can also be used for
  [`itemInclusionConstraint()`](https://beckerbenj.github.io/eatATA/reference/itemExclusionConstraint.md)
- argument names in
  [`itemTuples()`](https://beckerbenj.github.io/eatATA/reference/itemTuples.md)
  and
  [`itemExclusionConstraint()`](https://beckerbenj.github.io/eatATA/reference/itemExclusionConstraint.md)
  slightly modified
- added simulated item pools for examples
- renamed all item pools consistently (`items_mini`, `items_diao`,
  `items_pilot`, `items_vera`, `items_lsa`)

## eatATA 0.10.0

CRAN release: 2021-02-10

- argument `nItems` either completely removed from constraint functions
  or exchangeable with `itemIDs`
- `itemTargetConstraint()` substituted by `minimaxConstraint()`,
  `maximinConstraint()`, `maxConstraint()`, `minConstraint()`,
  `cappedMaximinConstraint()` which allow for different types of
  optimization goals
- `Symphony` added as available solver (via `Rsymphony`)
- [`inspectSolution()`](https://beckerbenj.github.io/eatATA/reference/inspectSolution.md)
  now allows character variables in the input if sums are calculated
- `autoItemValuesMinMax()` now works for different test length via
  `testLength` argument

### Documentation

- reworked use case vignette
- added minimal example vignette
- added vignette with package overview

### Internal Changes

- input checks (feasible solution?) for
  [`analyzeBlockExclusion()`](https://beckerbenj.github.io/eatATA/reference/analyzeBlockExclusion.md)
  and
  [`analyzeComplexBlockExclusion()`](https://beckerbenj.github.io/eatATA/reference/analyzeComplexBlockExclusion.md)
- uniqueness of argument `itemID` is checked
- introduction of `constraint`-class with specific methods and
  constructor functions

## eatATA 0.9.1

CRAN release: 2020-12-07

- `GLPK` and `lpSolve` solvers are now supported
- [`useSolver()`](https://beckerbenj.github.io/eatATA/reference/useSolver.md)
  function implemented, which calls solver APIs directly
- [`inspectSolution()`](https://beckerbenj.github.io/eatATA/reference/inspectSolution.md)
  and
  [`appendSolution()`](https://beckerbenj.github.io/eatATA/reference/appendSolution.md)
  functions, which use `useSovler()` output
- `prepareConstraints()` and `processGurobiOutput()` retired
- [`calculateIIF()`](https://beckerbenj.github.io/eatATA/reference/calculateIIF.md)
  calculates item information function
- [`calculateExpectedRT()`](https://beckerbenj.github.io/eatATA/reference/get_mean_3PLN.md)
  calculates expected response times

## eatATA 0.7.0

CRAN release: 2020-09-15

- Initial CRAN release.
