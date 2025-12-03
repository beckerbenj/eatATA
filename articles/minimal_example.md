# Typical Use of \`eatATA\`: a Minimal Example

`eatATA` efficiently translates test design requirements for Automated
Test Assembly (`ATA`) into constraints for a Mixed Integer Linear
Programming Model (MILP). A number of efficient and user-friendly
functions are available that translate conceptual test assembly
constraints to constraint objects for MILP solvers, like the `GLPK`
solver. In the remainder of this vignette we will illustrate the use of
`eatATA` using a minimal example. A general overview over `eatATA` can
be found in the vignette [Overview of `eatATA`
Functionality](https://beckerbenj.github.io/eatATA/articles/overview.md).

## Setup

The `eatATA` package can be installed from `CRAN`.

``` r
install.packages("eatATA")
```

## Item Pool

First, `eatATA` is loaded into your `R` session. In this vignette we use
a small simulated item pool, `items_mini`. The goal will be to assemble
a single test form consisting of ten items, an average test time of
eight minutes and maximum `TIF` at medium ability. We therefore
calculate the `IIF` at medium ability and append it to the item pool
using the `calculateIFF()` function.

``` r
# loading eatATA
library(eatATA)

# item pool structure
str(items_mini)
#> 'data.frame':    30 obs. of  4 variables:
#>  $ item      : int  1 2 3 4 5 6 7 8 9 10 ...
#>  $ format    : chr  "mc" "mc" "mc" "mc" ...
#>  $ time      : num  27.8 15.5 31 29.9 23.1 ...
#>  $ difficulty: num  -1.881 0.843 1.119 0.729 -0.489 ...

# calculate and append IIF
items_mini[, "IIF_0"] <- calculateIIF(B = items_mini$difficulty, theta = 0)
```

In Table 1 you can see the first five items of the item pool.

| item | format |   time | difficulty |     IIF_0 |
|-----:|:-------|-------:|-----------:|----------:|
|    1 | mc     | 27.786 |     -1.881 | 0.1090032 |
|    2 | mc     | 15.453 |      0.843 | 0.4494582 |
|    3 | mc     | 31.016 |      1.119 | 0.3266106 |
|    4 | mc     | 29.874 |      0.729 | 0.5033924 |
|    5 | mc     | 23.134 |     -0.489 | 0.6108816 |

Table 1. First 5 Items of the Item Pool

## Objective Function

Next, the objective function is defined: The `TIF` should be maximized
at medium ability. For this, we use the
[`maxObjective()`](https://beckerbenj.github.io/eatATA/reference/maxObjective.md)
function.

``` r
testInfo <- maxObjective(nForms = 1, itemValues = items_mini$IIF,
                          itemIDs = items_mini$item)
#> Warning in check_nItems_itemValues_itemIDs(nItems = nItems, itemIDs = itemIDs,
#> : 'itemValues' has rows and columns, only the values in the first column are
#> used.
```

## Constraints

Our further, fixed constraints are defined as additional constraint
objects.

``` r
itemNumber <- itemsPerFormConstraint(nForms = 1, operator = "=", 
                                     targetValue = 10, 
                                     itemIDs = items_mini$item)

itemUsage <- itemUsageConstraint(nForms = 1, operator = "<=", 
                                 targetValue = 1, 
                                 itemIDs = items_mini$item)

testTime <- itemValuesDeviationConstraint(nForms = 1, 
                                itemValues = items_mini$time,
                                targetValue = 8 * 60, 
                                allowedDeviation = 5,
                                relative = FALSE, 
                                itemIDs = items_mini$item)
```

Alternatively, we could determine the appropriate test time based on the
item pool using the `autoItemValuesMinMax()` function.

``` r
testTime2 <- autoItemValuesMinMaxConstraint(nForms = 1, 
                                itemValues = items_mini$time,
                                testLength = 10, 
                                allowedDeviation = 5,
                                relative = FALSE, 
                                itemIDs = items_mini$item)
#> The minimum and maximum values per test form are: min = 418.09 - max = 428.09
```

## Solver usage

To automatically assemble the test form based on our constraints, we
call the
[`useSolver()`](https://beckerbenj.github.io/eatATA/reference/useSolver.md)
function. In this function we define which solver should be used as back
end. As a default solver, we recommend `GLPK`, which is automatically
installed alongside this package.

``` r
solver_out <- useSolver(list(itemNumber, itemUsage, testTime, testInfo),
                        solver = "GLPK")
#> GLPK Simplex Optimizer 5.0
#> 34 rows, 31 columns, 151 non-zeros
#>       0: obj =  -0.000000000e+00 inf =   4.850e+02 (2)
#>      14: obj =  -0.000000000e+00 inf =   0.000e+00 (0)
#> *    34: obj =   6.734471402e+00 inf =   4.441e-16 (0)
#> OPTIMAL LP SOLUTION FOUND
#> GLPK Integer Optimizer 5.0
#> 34 rows, 31 columns, 151 non-zeros
#> 30 integer variables, all of which are binary
#> Integer optimization begins...
#> Long-step dual simplex will be used
#> +    34: mip =     not found yet <=              +inf        (1; 0)
#> +    44: >>>>>   6.579408205e+00 <=   6.732773863e+00   2.3% (9; 0)
#> +    46: >>>>>   6.729573876e+00 <=   6.729573876e+00   0.0% (7; 5)
#> +    46: mip =   6.729573876e+00 <=     tree is empty   0.0% (0; 19)
#> INTEGER OPTIMAL SOLUTION FOUND
```

## Inspect solution

The solution can be inspected directly via
[`inspectSolution()`](https://beckerbenj.github.io/eatATA/reference/inspectSolution.md)
or appended to the item pool via
[`appendSolution()`](https://beckerbenj.github.io/eatATA/reference/appendSolution.md).
Using the
[`inspectSolution()`](https://beckerbenj.github.io/eatATA/reference/inspectSolution.md)
function an additional row is created that calculates the column sums
for all numeric variables.

``` r
inspectSolution(solver_out, items = items_mini, idCol = "item")
#> $form_1
#>     item format      time  difficulty   theta=0
#> 8      8     mc  30.21856 -0.36707654 0.6564876
#> 14    14   open  62.99738  0.58136415 0.5712686
#> 15    15   open  56.59458 -0.12012428 0.7150196
#> 20    20   open  87.05063  0.10201223 0.7170949
#> 22    22  order  39.92415  0.15006395 0.7108712
#> 24    24  order  40.52289 -0.53606969 0.5910511
#> 25    25  order  52.15832  0.14083641 0.7122442
#> 26    26  order  38.29060  0.02381911 0.7222039
#> 28    28  order  43.77592  0.41298287 0.6403034
#> 29    29  order  25.55363  0.24091747 0.6930294
#> Sum  211   <NA> 477.08666  0.62872568 6.7295739
```

``` r
appendSolution(solver_out, items = items_mini, idCol = "item")
#>    item format     time  difficulty    theta=0 form_1
#> 1     1     mc 27.78586 -1.88090278 0.10900318      0
#> 2     2     mc 15.45258  0.84295865 0.44945822      0
#> 3     3     mc 31.01590  1.11881538 0.32661056      0
#> 4     4     mc 29.87421  0.72867743 0.50339241      0
#> 5     5     mc 23.13401 -0.48870993 0.61088162      0
#> 6     6     mc 25.19305  0.47273874 0.61733915      0
#> 7     7     mc 25.66340 -1.18054268 0.30183441      0
#> 8     8     mc 30.21856 -0.36707654 0.65648760      1
#> 9     9     mc 26.61642 -0.56879434 0.57682871      0
#> 10   10     mc 15.35510  1.35397237 0.23900562      0
#> 11   11   open 65.85163 -0.75879786 0.48917461      0
#> 12   12   open 35.94400  2.49927381 0.04012039      0
#> 13   13   open 78.85030  1.33165799 0.24650909      0
#> 14   14   open 62.99738  0.58136415 0.57126860      1
#> 15   15   open 56.59458 -0.12012428 0.71501958      1
#> 16   16   open 45.12778 -1.28629686 0.26229560      0
#> 17   17   open 48.11908 -0.86124314 0.44088544      0
#> 18   18   open 76.32293  0.76977036 0.48398822      0
#> 19   19   open 76.20244 -1.39388826 0.22601541      0
#> 20   20   open 87.05063  0.10201223 0.71709486      1
#> 21   21  order 22.47400 -0.43147145 0.63341304      0
#> 22   22  order 39.92415  0.15006395 0.71087118      1
#> 23   23  order 57.71593 -0.82071059 0.45992776      0
#> 24   24  order 40.52289 -0.53606969 0.59105111      1
#> 25   25  order 52.15832  0.14083641 0.71224418      1
#> 26   26  order 38.29060  0.02381911 0.72220392      1
#> 27   27  order 45.97548  2.79595336 0.02450104      0
#> 28   28  order 43.77592  0.41298287 0.64030341      1
#> 29   29  order 25.55363  0.24091747 0.69302944      1
#> 30   30  order 19.50162 -0.51434114 0.60026891      0
```
