# Capped Maximin Constraint.

Create `maximin`-constraints related to an item parameter/value. That
is, the created constraints can be used to maximize the minimal sum of
the item values (`itemValues`), while at the same time automatically
setting an ideal upper limit to the overflow. More specifically, the
`capped minimax` method described by Luo (2020) is used.

## Usage

``` r
cappedMaximinObjective(
  nForms,
  itemValues,
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

## References

Xiao Luo (2020). Automated Test Assembly with Mixed-Integer Programming:
The Effects of Modeling Approaches and Solvers. *Journal of Educational
Measurement*, 57(4), 547-565.
[doi:10.1111/jedm.12262](https://doi.org/10.1111/jedm.12262)

## Examples

``` r
# constraint that minimizes the maximum difference per test form value and a
#   target value of 0
cappedMaximinObjective(nForms = 2, itemValues = rep(-2:2, 2))
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
#>      [,1] [,2]
#> [1,]   -1    0
#> [2,]   -1    0
#> [3,]   -1   -1
#> [4,]   -1   -1
#> 
#> $operators
#> [1] ">=" ">=" "<=" "<="
#> 
#> $d
#> [1] 0 0 0 0
#> 
#> $c_binary
#> NULL
#> 
#> $c_real
#> [1]  1 -1
#> 
#> attr(,"class")
#> [1] "constraint"
#> attr(,"nForms")
#> [1] 2
#> attr(,"nItems")
#> [1] 10
#> attr(,"sense")
#> [1] "max"
#> attr(,"info")
#>   rowNr formNr itemNr                constraint
#> 1     1      1     NA rep(-2:2, 2)=0_lowerBound
#> 2     2      2     NA rep(-2:2, 2)=0_lowerBound
#> 3     3      1     NA rep(-2:2, 2)=0_upperBound
#> 4     4      2     NA rep(-2:2, 2)=0_upperBound
#> attr(,"itemIDs")
#>  [1] "it01" "it02" "it03" "it04" "it05" "it06" "it07" "it08" "it09" "it10"
```
