# Inspect a `useSolver` output

Process a `useSolver` output of a successfully solved optimization
problem to a list so it becomes humanly readable.

## Usage

``` r
inspectSolution(
  solverOut,
  items,
  idCol,
  colNames = names(items),
  colSums = TRUE
)
```

## Arguments

- solverOut:

  Object created by `useSolver` function.

- items:

  Original `data.frame` containing information on item level.

- idCol:

  Column name in `items` containing item IDs. These will be used for
  matching to the solver output.

- colNames:

  Which columns should be used from the `items` `data.frame`?

- colSums:

  Should column sums be calculated in the output? Only works if all
  columns are numeric.

## Value

A `list` with assembled blocks as entries. Rows are the individual
items. A final row is added, containing the sums of each column.

## Details

This function merges the initial item pool information in `items` to the
solver output in `solverOut`. Relevant columns can be selected via
`colNames`. Column sums within test forms are calculated if possible and
if `colSum` is set to `TRUE`.

## Examples

``` r
## Example item pool
items <- data.frame(ID = 1:10,
itemValues = c(-4, -4, -2, -2, -1, -1, 20, 20, 0, 0))

## Test Assembly
usage <- itemUsageConstraint(nForms = 2, operator = "=",
                             targetValue = 1, itemIDs = items$ID)
perForm <- itemsPerFormConstraint(nForms = 2, operator = "=",
                                  targetValue = 5, itemIDs = items$ID)
target <- minimaxObjective(nForms = 2,
                               itemValues = items$itemValues,
                               targetValue = 0, itemIDs = items$ID)
sol <- useSolver(allConstraints = list(usage, perForm, target),
                                  solver = "lpSolve")
#> Optimal solution found.

## Inspect Solution
out <- inspectSolution(sol, items = items, idCol = 1, colNames = "itemValues")
```
