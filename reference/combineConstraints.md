# Combine constraints

Combine multiple constraint-objects into one constraint object.

## Usage

``` r
combineConstraints(..., message = TRUE)
```

## Arguments

- ...:

  multiple constraint-objects or a list with multiple constraint-objects

- message:

  A logical indicating whether a message should be given when only one
  constraint object is combined.

## Value

A `data.frame` of block exclusions.

## Examples

``` r
combineConstraints(
 itemValuesConstraint(2, 1:10, operator = ">=", targetValue = 4),
 itemValuesConstraint(2, 1:10, operator = "<=", targetValue = 6)
)
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
