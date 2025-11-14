# Analyze block exclusiveness

Use exclusion tuples information to determine which assembled test
blocks are exclusive.

## Usage

``` r
analyzeBlockExclusion(
  solverOut,
  items,
  idCol,
  exclusionTuples,
  formName = "form"
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

- exclusionTuples:

  `data.frame` with two columns, containing tuples with item IDs which
  should be in test forms exclusively. Must be the same object as used
  in
  [`itemExclusionConstraint`](https://beckerbenj.github.io/eatATA/reference/itemExclusionConstraint.md).

- formName:

  A character vector with names to give to the forms.

## Value

A `data.frame` of block exclusions.

## Details

If exclusion tuples have been used to assemble test forms (using the
[`itemExclusionConstraint`](https://beckerbenj.github.io/eatATA/reference/itemExclusionConstraint.md)
function), the resulting item blocks might also be exclusive. Using the
initially used item exclusion tuples and the optimal solution given by
`useSolver` this function determines, which item blocks are exclusive
and can not be together in an assembled test form.

## Examples

``` r
## Full workflow using itemExclusionTuples
# Example data.frame
items <- data.frame(ID = c("items1", "items2", "items3", "items4"),
                     exclusions = c("items2, items3", NA, NA, NA),
                     stringsAsFactors = FALSE)

# Create tuples
exTuples2 <- itemTuples(items = items, idCol = "ID", infoCol = "exclusions",
                    sepPattern = ", ")

#' ## Create constraints
exclusion_constraint <- itemExclusionConstraint(nForms = 2, itemTuples = exTuples2,
                                                itemIDs = items$ID)
depletion_constraint <- depletePoolConstraint(2, nItems = 4,
                                                itemIDs = items$ID)
target_constraint <- minimaxObjective(nForms = 2,
                                          itemValues = c(3, 1.5, 2, 4),
                                          targetValue = 1,
                                          itemIDs = items$ID)

opt_solution <- useSolver(list(exclusion_constraint, target_constraint,
                                        depletion_constraint))
#> GLPK Simplex Optimizer 5.0
#> 12 rows, 9 columns, 36 non-zeros
#>       0: obj =   0.000000000e+00 inf =   6.000e+00 (6)
#>       8: obj =   4.250000000e+00 inf =   0.000e+00 (0)
#> *    10: obj =   4.250000000e+00 inf =   0.000e+00 (0)
#> OPTIMAL LP SOLUTION FOUND
#> GLPK Integer Optimizer 5.0
#> 12 rows, 9 columns, 36 non-zeros
#> 8 integer variables, all of which are binary
#> Integer optimization begins...
#> Long-step dual simplex will be used
#> +    10: mip =     not found yet >=              -inf        (1; 0)
#> +    14: >>>>>   6.000000000e+00 >=   4.250000000e+00  29.2% (2; 0)
#> +    17: mip =   6.000000000e+00 >=     tree is empty   0.0% (0; 3)
#> INTEGER OPTIMAL SOLUTION FOUND
#> Optimal solution found.

analyzeBlockExclusion(opt_solution, items = items, idCol = "ID",
                       exclusionTuples = exTuples2)
#>   Name 1 Name 2
#> 1 form_1 form_2

```
