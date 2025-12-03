# Minimax Constraint.

Create `minimax`-constraints related to an item parameter/value. That
is, the created constraints can be used to minimize the maximum distance
between the sum of the item values (`itemValues`) per test form and the
chosen `targetValue`.

## Usage

``` r
minimaxObjective(
  nForms,
  itemValues,
  targetValue,
  weight = 1,
  whichForms = seq_len(nForms),
  info_text = NULL,
  itemIDs = names(itemValues)
)
```

## Arguments

- nForms:

  Number of forms to be created.

- itemValues:

  Item parameter/values for which the sum per test form should be
  constrained.

- targetValue:

  the target test form value.

- weight:

  a weight for the real-valued variable(s). Useful when multiple
  constraints are combined. Should only be used if the implications are
  well understood.

- whichForms:

  An integer vector indicating which test forms should be constrained.
  Defaults to all the test forms.

- info_text:

  a character string of length 1, to be used in the `"info"`-attribute
  of the resulting `constraint`-object.

- itemIDs:

  a character vector of item IDs in correct ordering, or NULL.

## Value

An object of class `"constraint"`.

## Examples

``` r
# constraint that minimizes the maximum difference per test form value and a
#   target value of 0
minimaxObjective(nForms = 2,
                 itemValues = rep(-2:2, 2),
                 targetValue = 0)
#> Warning: Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.
#> $A_binary
#> 4 x 20 sparse Matrix of class "dgCMatrix"
#>                                                     
#> [1,] -2 -1 0 1 2 -2 -1 0 1 2  .  . . . .  .  . . . .
#> [2,]  .  . . . .  .  . . . . -2 -1 0 1 2 -2 -1 0 1 2
#> [3,] -2 -1 0 1 2 -2 -1 0 1 2  .  . . . .  .  . . . .
#> [4,]  .  . . . .  .  . . . . -2 -1 0 1 2 -2 -1 0 1 2
#> 
#> $A_real
#>      [,1]
#> [1,]   -1
#> [2,]   -1
#> [3,]    1
#> [4,]    1
#> 
#> $operators
#> [1] "<=" "<=" ">=" ">="
#> 
#> $d
#> [1] 0 0 0 0
#> 
#> $c_binary
#> NULL
#> 
#> $c_real
#> [1] 1
#> 
#> attr(,"class")
#> [1] "constraint"
#> attr(,"nForms")
#> [1] 2
#> attr(,"nItems")
#> [1] 10
#> attr(,"sense")
#> [1] "min"
#> attr(,"info")
#>   rowNr formNr itemNr                constraint
#> 1     1      1     NA rep(-2:2, 2)=0_lowerBound
#> 2     2      2     NA rep(-2:2, 2)=0_lowerBound
#> 3     3      1     NA rep(-2:2, 2)=0_upperBound
#> 4     4      2     NA rep(-2:2, 2)=0_upperBound
#> attr(,"itemIDs")
#>  [1] "it01" "it02" "it03" "it04" "it05" "it06" "it07" "it08" "it09" "it10"
```
