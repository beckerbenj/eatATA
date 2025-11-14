# Create item exclusion tuples from matrix.

If item exclusions are stored as a matrix, `matrixExclusionTuples`
transforms this format into item pairs ('tuples'). Information on
exclusions has to be coded as `1` (items are exclusive) and `0` (items
are not exclusive).

## Usage

``` r
matrixExclusionTuples(exclMatrix)
```

## Arguments

- exclMatrix:

  A `data.frame` or `matrix` with information on item exclusiveness.

## Value

A `data.frame` with two columns.

## Details

Exclusion tuples can be used by
[`itemExclusionConstraint`](https://beckerbenj.github.io/eatATA/reference/itemExclusionConstraint.md)
to set up exclusion constraints.

## Examples

``` r
# Example data.frame
exclDF <- data.frame(c(0, 1, 0, 0),
                     c(1, 0, 0, 1),
                     c(0, 0, 0, 0),
                     c(0, 1, 0, 0))
rownames(exclDF) <- colnames(exclDF) <- paste0("item_", 1:4)

# Create tuples
matrixExclusionTuples(exclDF)
#>      [,1]     [,2]    
#> [1,] "item_1" "item_2"
#> [2,] "item_2" "item_4"

```
