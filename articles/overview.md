# Overview of \`eatATA\` Functionality

`eatATA` efficiently translates test design requirements for Automated
Test Assembly (`ATA`) into constraints for a Mixed Integer Linear
Programming Model (MILP). A number of user-friendly functions are
available that translate conceptual test assembly constraints to
constraint objects for MILP solver. Currently, `GLPK`, `lpSolve`,
`SYMPHONY`, and `Gurobi` are supported as solvers. In the remainder of
this vignette we provide an overview of the functionality of `eatATA`. A
minimal `ATA` example can be found in the vignette [Typical Use of
`eatATA`: a Minimal
Example](https://beckerbenj.github.io/eatATA/articles/minimal_example.md),
a more complex use case for a pilot study can be found in the vignette
[Typical Use of `eatATA`: a Pilot Study
Example](https://beckerbenj.github.io/eatATA/articles/use_case_pilot_study.md).

## Setup

The `eatATA` package can be installed from `CRAN`.

``` r
install.packages("eatATA")
```

As a default solver, we recommend `GLPK`, which is automatically
installed alongside this package. `lpSolve` and `SYMPHONY` are also
freely available open source solvers. If you want to use `Gurobi` as a
solver (the most powerful and efficient solver currently supported by
`eatATA`), an external software installation and licensing is required.
This means, you need to install the `Gurobi` solver and its
corresponding `R` package. A detailed vignette on the installation
process can be found
[here](https://CRAN.R-project.org/package=prioritizr/vignettes/gurobi_installation_guide.html).

``` r
# loading eatATA
library(eatATA)
```

## Item pool preparation

`eatATA` provides functions to prepare the item pool for test assembly:

- [`calculateIIF()`](https://beckerbenj.github.io/eatATA/reference/calculateIIF.md)
- `calculatExpectedRT()`
- [`dummiesToFactor()`](https://beckerbenj.github.io/eatATA/reference/dummiesToFactor.md)
- [`computeTargetValues()`](https://beckerbenj.github.io/eatATA/reference/computeTargetValues.md)

These functions can be used to calculate the item information function
([`calculateIIF()`](https://beckerbenj.github.io/eatATA/reference/calculateIIF.md))
and expected response times (`calculatExpectedRT()`).
[`dummiesToFactor()`](https://beckerbenj.github.io/eatATA/reference/dummiesToFactor.md)
allows the transformation of a variable coded as multiple dummy
variables into a single factor.
[`computeTargetValues()`](https://beckerbenj.github.io/eatATA/reference/computeTargetValues.md)
allows the calculation of target values for test form constraints, but
this functionality is also contained in the `autoItemValuesMinMax()`
function.

There also a number of example item pools included in the package: \*
`items_mini`: A small minimal example item pool \* `items_diao`: An item
pool modeled after the first problem in Diao & van der Linden (2011) \*
`items_pilot`: An item pool for a calibration study \* `items_lsa`: An
item pool for the block assembly of a large-scale assessment \*
`items_vera`: An item pool similar to a `Vergleichsarbeiten` item pool

## Objective function

Constraints defining the optimization goal of the automated test
assembly:

- [`maxObjective()`](https://beckerbenj.github.io/eatATA/reference/maxObjective.md)
- [`minObjective()`](https://beckerbenj.github.io/eatATA/reference/minObjective.md)
- [`maximinObjective()`](https://beckerbenj.github.io/eatATA/reference/maximinObjective.md)
- [`minimaxObjective()`](https://beckerbenj.github.io/eatATA/reference/minimaxObjective.md)
- [`cappedMaximinObjective()`](https://beckerbenj.github.io/eatATA/reference/cappedMaximinObjective.md)

## Constraints

Here is a list of functions that can be used to set constraints:

Constraints controlling how often an item should or can be used:

- [`depletePoolConstraint()`](https://beckerbenj.github.io/eatATA/reference/depletePoolConstraint.md)
- [`itemUsageConstraint()`](https://beckerbenj.github.io/eatATA/reference/itemUsageConstraint.md)

Constraints controlling number of items per test forms:

- [`itemUsageConstraint()`](https://beckerbenj.github.io/eatATA/reference/itemUsageConstraint.md)
- [`itemsPerFormConstraint()`](https://beckerbenj.github.io/eatATA/reference/itemsPerFormConstraint.md)

Constraints controlling categorical properties of items per test forms:

- [`itemCategoryConstraint()`](https://beckerbenj.github.io/eatATA/reference/itemCategoryConstraint.md)
- [`itemCategoryDeviationConstraint()`](https://beckerbenj.github.io/eatATA/reference/itemCategoryRangeConstraint.md)
- [`itemCategoryMaxConstraint()`](https://beckerbenj.github.io/eatATA/reference/itemCategoryRangeConstraint.md)
- [`itemCategoryMinConstraint()`](https://beckerbenj.github.io/eatATA/reference/itemCategoryRangeConstraint.md)
- [`itemCategoryRangeConstraint()`](https://beckerbenj.github.io/eatATA/reference/itemCategoryRangeConstraint.md)

Constraints controlling metric properties of items per test forms:

- [`autoItemValuesMinMaxConstraint()`](https://beckerbenj.github.io/eatATA/reference/autoItemValuesMinMaxConstraint.md)
- [`itemValuesConstraint()`](https://beckerbenj.github.io/eatATA/reference/itemValuesConstraint.md)
- [`itemValuesDeviationConstraint()`](https://beckerbenj.github.io/eatATA/reference/itemValuesRangeConstraint.md)
- [`itemValuesMaxConstraint()`](https://beckerbenj.github.io/eatATA/reference/itemValuesRangeConstraint.md)
- [`itemValuesMinConstraint()`](https://beckerbenj.github.io/eatATA/reference/itemValuesRangeConstraint.md)
- [`itemValuesRangeConstraint()`](https://beckerbenj.github.io/eatATA/reference/itemValuesRangeConstraint.md)

Constraints controlling metric properties of items across test forms:

- [`acrossFormsConstraint()`](https://beckerbenj.github.io/eatATA/reference/acrossFormsConstraint.md)

Constraints controlling item inclusions or exclusions within test forms:

- [`itemExclusionConstraint()`](https://beckerbenj.github.io/eatATA/reference/itemExclusionConstraint.md)
- [`itemInclusionConstraint()`](https://beckerbenj.github.io/eatATA/reference/itemExclusionConstraint.md)

Input for the inclusion and exclusion function can be prepared using:

- [`itemTuples()`](https://beckerbenj.github.io/eatATA/reference/itemTuples.md)
- [`matrixExclusionTuples()`](https://beckerbenj.github.io/eatATA/reference/matrixExclusionTuples.md)
- [`stemInclusionTuples()`](https://beckerbenj.github.io/eatATA/reference/stemInclusionTuples.md)

## Solver function

After defining all required constraints using the functions above,
[`useSolver()`](https://beckerbenj.github.io/eatATA/reference/useSolver.md)
can be used to call the desired solver. Optionally, constraints can be
combined beforehand using the `combineConstraint()` function.

## Using the solver output

[`useSolver()`](https://beckerbenj.github.io/eatATA/reference/useSolver.md)
structures the output consistently, independent of the solver used. This
output can be further processed by
[`inspectSolution()`](https://beckerbenj.github.io/eatATA/reference/inspectSolution.md)
(to inspect the assembled booklets) and
[`appendSolution()`](https://beckerbenj.github.io/eatATA/reference/appendSolution.md)
(to append the assembly information to the existing item `data.frame`).

## Booklet exclusions

Test form assembly might be performed in a two stage process, first
assembling booklets from items and then assembling test forms from
booklets. In this case, item exclusions might translate to exclusions on
booklets level. Booklet exclusions can exist between booklets of one
automated booklet assembly run or between booklets of multiple automated
booklet assembly runs. For the first case,
[`analyzeBlockExclusion()`](https://beckerbenj.github.io/eatATA/reference/analyzeBlockExclusion.md)
can be used to inspect booklet exclusions. For the second case,
[`analyzeComplexBlockExclusion()`](https://beckerbenj.github.io/eatATA/reference/analyzeComplexBlockExclusion.md)
can be used to inspect booklet exclusions.
