# Create number of items per test form constraints.

Creates constraints related to the number of items in each test form.

## Usage

``` r
itemsPerFormConstraint(
  nForms,
  nItems = NULL,
  operator = c("<=", "=", ">="),
  targetValue,
  whichForms = seq_len(nForms),
  itemIDs = NULL
)
```

## Arguments

- nForms:

  Number of forms to be created.

- nItems:

  Number of items in the item pool \[optional to create `itemIDs`
  automatically\].

- operator:

  A character indicating which operator should be used in the
  constraints, with three possible values: `"<="`, `"="`, or `">="`. See
  details for more information.

- targetValue:

  The target value to be used in the constraints. That is, the number of
  items per form.

- whichForms:

  An integer vector indicating which test forms should be constrained.
  Defaults to all the test forms.

- itemIDs:

  a character vector of item IDs in correct ordering, or NULL.

## Value

An object of class `"constraint"`.

## Details

The number of items per test form is constrained to be either (a)
smaller or equal than (`operator = "<="`), (b) equal to
(`operator = "="`), or (c) greater or equal than (`operator = ">="`) the
chosen `value`.

## Examples

``` r
## Constrain the test forms to have exactly five items
itemsPerFormConstraint(3, operator = "=", targetValue = 5,
                       itemIDs = 1:20)
#> $A_binary
#> 3 x 60 sparse Matrix of class "dgCMatrix"
#>                                                                               
#> [1,] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 . . . . . . . . . . . . . . . . .
#> [2,] . . . . . . . . . . . . . . . . . . . . 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
#> [3,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>                                                   
#> [1,] . . . . . . . . . . . . . . . . . . . . . . .
#> [2,] 1 1 1 . . . . . . . . . . . . . . . . . . . .
#> [3,] . . . 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
#> 
#> $A_real
#> NULL
#> 
#> $operators
#> [1] "=" "=" "="
#> 
#> $d
#> [1] 5 5 5
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
#> [1] 3
#> attr(,"nItems")
#> [1] 20
#> attr(,"info")
#>   rowNr formNr itemNr     constraint
#> 1     1      1     NA itemsPerForm=5
#> 2     2      2     NA itemsPerForm=5
#> 3     3      3     NA itemsPerForm=5
#> attr(,"itemIDs")
#>  [1]  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20
```
