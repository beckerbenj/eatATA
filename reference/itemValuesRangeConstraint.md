# Create single value constraints with minimum and maximum.

`itemValuesRangeConstraint`, `itemValuesMinConstraint`, and
`itemValuesMaxConstraint` create constraints related to an item
parameter/value. That is, the created constraints assure that the sum of
the `itemValues` is smaller than or equal to `max`, greater than or
equal to `min`, or both `range`.

## Usage

``` r
itemValuesRangeConstraint(
  nForms,
  itemValues,
  range,
  whichForms = seq_len(nForms),
  info_text = NULL,
  itemIDs = names(itemValues)
)

itemValuesMinConstraint(
  nForms,
  itemValues,
  min,
  whichForms = seq_len(nForms),
  info_text = NULL,
  itemIDs = names(itemValues)
)

itemValuesMaxConstraint(
  nForms,
  itemValues,
  max,
  whichForms = seq_len(nForms),
  info_text = NULL,
  itemIDs = names(itemValues)
)

itemValuesDeviationConstraint(
  nForms,
  itemValues,
  targetValue,
  allowedDeviation,
  relative = FALSE,
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

- range:

  a vector with two values, the the minimal and the maximum sum of the
  `itemValues` per test form, respectively

- whichForms:

  An integer vector indicating which test forms should be constrained.
  Defaults to all the test forms.

- info_text:

  a character string of length 1, to be used in the `"info"`-attribute
  of the resulting `constraint`-object.

- itemIDs:

  a character vector of item IDs in correct ordering, or NULL.

- min:

  the minimal sum of the `itemValues` per test form

- max:

  the maximal sum of the `itemValues` per test form

- targetValue:

  the target test form value.

- allowedDeviation:

  the maximum allowed deviation from the `targetValue`

- relative:

  a logical expressing whether or not the `allowedDeviation` should be
  interpreted as a proportion of the `targetValue`

## Value

An object of class `"constraint"`.

## Details

`itemValuesDeviationConstraint` also constrains the minimal and the
maximal value of the sum of the `itemValues`, but based on a chosen and
a maximal allowed deviation (i.e., `allowedDeviation`) from that
`targetValue`.

## Functions

- `itemValuesMinConstraint()`: constrain minimum value

- `itemValuesMaxConstraint()`: constrain maximum value

- `itemValuesDeviationConstraint()`: constrain the distance form the
  `targetValue`

## Examples

``` r
## constraints to make sure that the sum of the item values (1:10) is between
## 4 and 6
itemValuesRangeConstraint(2, 1:10, range(min = 4, max = 6))
#> Warning: Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.
#> Warning: Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.
#> $A_binary
#> 4 x 20 sparse Matrix of class "dgCMatrix"
#>                                               
#> [1,] 1 2 3 4 5 6 7 8 9 10 . . . . . . . . .  .
#> [2,] . . . . . . . . .  . 1 2 3 4 5 6 7 8 9 10
#> [3,] 1 2 3 4 5 6 7 8 9 10 . . . . . . . . .  .
#> [4,] . . . . . . . . .  . 1 2 3 4 5 6 7 8 9 10
#> 
#> $A_real
#> NULL
#> 
#> $operators
#> [1] ">=" ">=" "<=" "<="
#> 
#> $d
#> [1] 4 4 6 6
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
#> [1] 10
#> attr(,"info")
#>   rowNr formNr itemNr constraint
#> 1     1      1     NA    1:10>=4
#> 2     2      2     NA    1:10>=4
#> 3     3      1     NA    1:10<=6
#> 4     4      2     NA    1:10<=6
#> attr(,"itemIDs")
#>  [1] "it01" "it02" "it03" "it04" "it05" "it06" "it07" "it08" "it09" "it10"

## or alternatively
itemValuesDeviationConstraint(2, 1:10, targetValue = 5,
allowedDeviation = 1)
#> Warning: Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.
#> Warning: Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.
#> $A_binary
#> 4 x 20 sparse Matrix of class "dgCMatrix"
#>                                               
#> [1,] 1 2 3 4 5 6 7 8 9 10 . . . . . . . . .  .
#> [2,] . . . . . . . . .  . 1 2 3 4 5 6 7 8 9 10
#> [3,] 1 2 3 4 5 6 7 8 9 10 . . . . . . . . .  .
#> [4,] . . . . . . . . .  . 1 2 3 4 5 6 7 8 9 10
#> 
#> $A_real
#> NULL
#> 
#> $operators
#> [1] ">=" ">=" "<=" "<="
#> 
#> $d
#> [1] 4 4 6 6
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
#> [1] 10
#> attr(,"info")
#>   rowNr formNr itemNr constraint
#> 1     1      1     NA    1:10>=4
#> 2     2      2     NA    1:10>=4
#> 3     3      1     NA    1:10<=6
#> 4     4      2     NA    1:10<=6
#> attr(,"itemIDs")
#>  [1] "it01" "it02" "it03" "it04" "it05" "it06" "it07" "it08" "it09" "it10"
```
