# Append a `useSolver` output

Append a `useSolver` output of a successfully solved optimization
problem to the initial item pool `data.frame`.

## Usage

``` r
appendSolution(solverOut, items, idCol)
```

## Arguments

- solverOut:

  Object created by `useSolver` function.

- items:

  Original `data.frame` containing information on item level.

- idCol:

  Column name or column number in `items` containing item IDs. These
  will be used for matching to the solver output.

## Value

A `data.frame`.

## Details

This function merges the initial item pool information in `items` to the
solver output in `solverOut`.

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

## Append Solution to existing item information
out <- appendSolution(sol, items = items, idCol = 1)
```
