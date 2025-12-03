# Min Constraint.

Create `min`-constraints related to an item parameter/value. That is,
the created constraints can be used to minimize the sum of the item
values (`itemValues`) of the test form. Note that this constraint can
only be used when only one test form has to be assembled.

## Usage

``` r
minObjective(
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

## Examples

``` r
# constraint that maximizes the sum of the itemValues
maxObjective(nForms = 1, itemValues = rep(-2:2, 2))
#> Warning: Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.
#> $A_binary
#> 1 x 10 sparse Matrix of class "dgCMatrix"
#>                             
#> [1,] -2 -1 0 1 2 -2 -1 0 1 2
#> 
#> $A_real
#>      [,1]
#> [1,]   -1
#> 
#> $operators
#> [1] ">="
#> 
#> $d
#> [1] 0
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
#> [1] 1
#> attr(,"nItems")
#> [1] 10
#> attr(,"sense")
#> [1] "max"
#> attr(,"info")
#>   rowNr formNr itemNr     constraint
#> 1     1      1     NA rep(-2:2, 2)=0
#> attr(,"itemIDs")
#>  [1] "it01" "it02" "it03" "it04" "it05" "it06" "it07" "it08" "it09" "it10"
```
