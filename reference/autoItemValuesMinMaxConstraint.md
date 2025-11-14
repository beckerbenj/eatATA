# Create single value constraints with minimum and maximum.

[`itemValuesDeviationConstraint`](https://beckerbenj.github.io/eatATA/reference/itemValuesRangeConstraint.md)
creates constraints related to an item parameter/value.
`autoItemValuesMixMax` automatically determines the appropriate
`targetValue` and then calls
[`itemValuesDeviationConstraint`](https://beckerbenj.github.io/eatATA/reference/itemValuesRangeConstraint.md).
The function only works for (dichotomous) dummy indicators with values 0
or 1.

## Usage

``` r
autoItemValuesMinMaxConstraint(
  nForms,
  itemValues,
  testLength = NULL,
  allowedDeviation = NULL,
  relative = FALSE,
  verbose = TRUE,
  itemIDs = NULL
)
```

## Arguments

- nForms:

  Number of forms to be created.

- itemValues:

  Item parameter/values for which the sum per test form should be
  constrained.

- testLength:

  to be documented.

- allowedDeviation:

  Numeric value of length 1. How much deviance is allowed from target
  values?

- relative:

  Is the `allowedDeviation` expressed as a proportion?

- verbose:

  Should calculated values be reported?

- itemIDs:

  a character vector of item IDs in correct ordering, or NULL.

## Value

A sparse matrix.

## Details

Two scenarios are possible when automatically determining the target
value: (a) Either items with the selected property could be exactly
distributed across test forms or (b) this is not possible. An example
would be 2 test forms and 4 multiple choice items (a) or 2 test forms
and 5 multiple choice items (b). If (a), the tolerance level works
exactly as one would expect. If (b) the tolerance level is adapted,
meaning that if tolerance level is 0 in example (b), allowed values are
2 or 3 multiple choice items per test form. For detailed documentation
on how the minimum and maximum are calculated see also
[`computeTargetValues`](https://beckerbenj.github.io/eatATA/reference/computeTargetValues.md).

## Examples

``` r
autoItemValuesMinMaxConstraint(2, itemValues = c(0, 1, 0, 1))
#> Warning: Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.
#> The target value per test form is: 1
#> $A_binary
#> 2 x 8 sparse Matrix of class "dgCMatrix"
#>                     
#> [1,] 0 1 0 1 . . . .
#> [2,] . . . . 0 1 0 1
#> 
#> $A_real
#> NULL
#> 
#> $operators
#> [1] "=" "="
#> 
#> $d
#> [1] 1 1
#> 
#> $c_binary
#> NULL
#> 
#> $c_real
#> NULL
#> 
#> attr(,"class")
#> [1] "constraint"
#> attr(,"nForms")
#> [1] 2
#> attr(,"nItems")
#> [1] 4
#> attr(,"info")
#>   rowNr formNr itemNr   constraint
#> 1     1      1     NA itemValues=1
#> 2     2      2     NA itemValues=1
#> attr(,"itemIDs")
#> [1] "it1" "it2" "it3" "it4"
```
