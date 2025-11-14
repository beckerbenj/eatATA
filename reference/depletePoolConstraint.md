# Use complete item pool.

Creates constraints that assure that every item in the item pool is used
(at least) once. Essentially a wrapper around `itemUsageConstraint`.

## Usage

``` r
depletePoolConstraint(nForms, nItems = NULL, itemIDs = NULL)
```

## Arguments

- nForms:

  Number of forms to be created.

- nItems:

  Number of items in the item pool \[optional to create `itemIDs`
  automatically\].

- itemIDs:

  a character vector of item IDs in correct ordering, or NULL.

## Value

A sparse matrix.

## Examples

``` r
depletePoolConstraint(2, itemIDs = 1:10)
#> $A_binary
#> 10 x 20 sparse Matrix of class "dgCMatrix"
#>                                              
#>  [1,] 1 . . . . . . . . . 1 . . . . . . . . .
#>  [2,] . 1 . . . . . . . . . 1 . . . . . . . .
#>  [3,] . . 1 . . . . . . . . . 1 . . . . . . .
#>  [4,] . . . 1 . . . . . . . . . 1 . . . . . .
#>  [5,] . . . . 1 . . . . . . . . . 1 . . . . .
#>  [6,] . . . . . 1 . . . . . . . . . 1 . . . .
#>  [7,] . . . . . . 1 . . . . . . . . . 1 . . .
#>  [8,] . . . . . . . 1 . . . . . . . . . 1 . .
#>  [9,] . . . . . . . . 1 . . . . . . . . . 1 .
#> [10,] . . . . . . . . . 1 . . . . . . . . . 1
#> 
#> $A_real
#> NULL
#> 
#> $operators
#>  [1] ">=" ">=" ">=" ">=" ">=" ">=" ">=" ">=" ">=" ">="
#> 
#> $d
#>  [1] 1 1 1 1 1 1 1 1 1 1
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
#>    rowNr formNr itemNr        constraint
#> 1      1     NA      1 rep(1, nForms)>=1
#> 2      2     NA      2 rep(1, nForms)>=1
#> 3      3     NA      3 rep(1, nForms)>=1
#> 4      4     NA      4 rep(1, nForms)>=1
#> 5      5     NA      5 rep(1, nForms)>=1
#> 6      6     NA      6 rep(1, nForms)>=1
#> 7      7     NA      7 rep(1, nForms)>=1
#> 8      8     NA      8 rep(1, nForms)>=1
#> 9      9     NA      9 rep(1, nForms)>=1
#> 10    10     NA     10 rep(1, nForms)>=1
#> attr(,"itemIDs")
#>  [1]  1  2  3  4  5  6  7  8  9 10
```
