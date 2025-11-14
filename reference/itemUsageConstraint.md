# Create item usage constraints.

Creates constraints related to item usage. That is, the number of times
an item is selected is constrained to be either (a) smaller or equal
than (`operator = "<="`), (b) equal to (`operator = "="`), or (c)
greater or equal than (`operator = ">="`) the chosen `value`.

## Usage

``` r
itemUsageConstraint(
  nForms,
  nItems = NULL,
  formValues = rep(1, nForms),
  operator = c("<=", "=", ">="),
  targetValue = 1,
  whichItems = NULL,
  info_text = NULL,
  itemIDs = NULL
)
```

## Arguments

- nForms:

  Number of forms to be created.

- nItems:

  Number of items in the item pool \[optional to create `itemIDs`
  automatically\].

- formValues:

  vector with values or weights for each form. Defaults to 1 for each
  form.

- operator:

  A character indicating which operator should be used in the
  constraints, with three possible values: `"<="`, `"="`, or `">="`. See
  details for more information.

- targetValue:

  The value to be used in the constraints

- whichItems:

  A vector indicating which items should be constrained. Defaults to all
  the items.

- info_text:

  a character string of length 1, to be used in the `"info"`-attribute
  of the resulting `constraint`-object.

- itemIDs:

  a character vector of item IDs in correct ordering, or NULL.

## Value

An object of class `"constraint"`.

## Details

When `operator = "<="` and `value = 1` (the default), each item can be
selected maximally once, which corresponds with assuring that there is
no item overlap between the forms. When `operator = "="` and
`value = 1`, each item is used exactly once, which corresponds to no
item-overlap and complete item pool depletion.

If certain items are required in the resulting test form(s), as for
example anchor items, `whichItems` can be used to constrain the usage of
these items to be exactly 1. `whichItems` can either be a numeric vector
with item numbers or a character vector with item identifiers
corresponding to `itemIDs`.

## Examples

``` r
## create no-item overlap constraints with item pool depletion
##  for 2 test forms with an item pool of 20 items
itemUsageConstraint(2, operator = "=", targetValue = 1,
                    itemIDs = 1:20)
#> $A_binary
#> 20 x 40 sparse Matrix of class "dgCMatrix"
#>                                                                                
#>  [1,] 1 . . . . . . . . . . . . . . . . . . . 1 . . . . . . . . . . . . . . . .
#>  [2,] . 1 . . . . . . . . . . . . . . . . . . . 1 . . . . . . . . . . . . . . .
#>  [3,] . . 1 . . . . . . . . . . . . . . . . . . . 1 . . . . . . . . . . . . . .
#>  [4,] . . . 1 . . . . . . . . . . . . . . . . . . . 1 . . . . . . . . . . . . .
#>  [5,] . . . . 1 . . . . . . . . . . . . . . . . . . . 1 . . . . . . . . . . . .
#>  [6,] . . . . . 1 . . . . . . . . . . . . . . . . . . . 1 . . . . . . . . . . .
#>  [7,] . . . . . . 1 . . . . . . . . . . . . . . . . . . . 1 . . . . . . . . . .
#>  [8,] . . . . . . . 1 . . . . . . . . . . . . . . . . . . . 1 . . . . . . . . .
#>  [9,] . . . . . . . . 1 . . . . . . . . . . . . . . . . . . . 1 . . . . . . . .
#> [10,] . . . . . . . . . 1 . . . . . . . . . . . . . . . . . . . 1 . . . . . . .
#> [11,] . . . . . . . . . . 1 . . . . . . . . . . . . . . . . . . . 1 . . . . . .
#> [12,] . . . . . . . . . . . 1 . . . . . . . . . . . . . . . . . . . 1 . . . . .
#> [13,] . . . . . . . . . . . . 1 . . . . . . . . . . . . . . . . . . . 1 . . . .
#> [14,] . . . . . . . . . . . . . 1 . . . . . . . . . . . . . . . . . . . 1 . . .
#> [15,] . . . . . . . . . . . . . . 1 . . . . . . . . . . . . . . . . . . . 1 . .
#> [16,] . . . . . . . . . . . . . . . 1 . . . . . . . . . . . . . . . . . . . 1 .
#> [17,] . . . . . . . . . . . . . . . . 1 . . . . . . . . . . . . . . . . . . . 1
#> [18,] . . . . . . . . . . . . . . . . . 1 . . . . . . . . . . . . . . . . . . .
#> [19,] . . . . . . . . . . . . . . . . . . 1 . . . . . . . . . . . . . . . . . .
#> [20,] . . . . . . . . . . . . . . . . . . . 1 . . . . . . . . . . . . . . . . .
#>            
#>  [1,] . . .
#>  [2,] . . .
#>  [3,] . . .
#>  [4,] . . .
#>  [5,] . . .
#>  [6,] . . .
#>  [7,] . . .
#>  [8,] . . .
#>  [9,] . . .
#> [10,] . . .
#> [11,] . . .
#> [12,] . . .
#> [13,] . . .
#> [14,] . . .
#> [15,] . . .
#> [16,] . . .
#> [17,] . . .
#> [18,] 1 . .
#> [19,] . 1 .
#> [20,] . . 1
#> 
#> $A_real
#> NULL
#> 
#> $operators
#>  [1] "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "="
#> [20] "="
#> 
#> $d
#>  [1] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
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
#> [1] 20
#> attr(,"info")
#>    rowNr formNr itemNr       constraint
#> 1      1     NA      1 rep(1, nForms)=1
#> 2      2     NA      2 rep(1, nForms)=1
#> 3      3     NA      3 rep(1, nForms)=1
#> 4      4     NA      4 rep(1, nForms)=1
#> 5      5     NA      5 rep(1, nForms)=1
#> 6      6     NA      6 rep(1, nForms)=1
#> 7      7     NA      7 rep(1, nForms)=1
#> 8      8     NA      8 rep(1, nForms)=1
#> 9      9     NA      9 rep(1, nForms)=1
#> 10    10     NA     10 rep(1, nForms)=1
#> 11    11     NA     11 rep(1, nForms)=1
#> 12    12     NA     12 rep(1, nForms)=1
#> 13    13     NA     13 rep(1, nForms)=1
#> 14    14     NA     14 rep(1, nForms)=1
#> 15    15     NA     15 rep(1, nForms)=1
#> 16    16     NA     16 rep(1, nForms)=1
#> 17    17     NA     17 rep(1, nForms)=1
#> 18    18     NA     18 rep(1, nForms)=1
#> 19    19     NA     19 rep(1, nForms)=1
#> 20    20     NA     20 rep(1, nForms)=1
#> attr(,"itemIDs")
#>  [1]  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20

## force certain items to be in the test, others not
usage1 <- itemUsageConstraint(2, operator = "<=", targetValue = 1,
                    itemIDs = paste0("item", 1:20))
usage2 <- itemUsageConstraint(2, operator = "=", targetValue = 1,
                    itemIDs = paste0("item", 1:20),
                    whichItems = c("item5", "item8", "item10"))
```
