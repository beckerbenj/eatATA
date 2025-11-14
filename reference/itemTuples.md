# Create item tuples.

If item inclusions or exclusions are stored as a character vector,
`itemTuples` separates this vector and creates item pairs ('tuples').

## Usage

``` r
itemTuples(items, idCol = "ID", infoCol, sepPattern = ", ")
```

## Arguments

- items:

  A `data.frame` with information on an item pool.

- idCol:

  character or integer indicating the item ID column in `items`.

- infoCol:

  character or integer indicating the column in `items` which contains
  information on the tuples.

- sepPattern:

  String which should be used for separating item IDs in the `infoCol`
  column.

## Value

A `data.frame` with two columns.

## Details

Tuples can be used by
[`itemExclusionConstraint`](https://beckerbenj.github.io/eatATA/reference/itemExclusionConstraint.md)
to set up exclusion constraints and by
[`itemInclusionConstraint`](https://beckerbenj.github.io/eatATA/reference/itemExclusionConstraint.md)
to set up inclusion constraints. Note that a separator pattern has to be
used consistently throughout the column (e.g. `", "`).

## Examples

``` r
# Example data.frame
items <- data.frame(ID = c("item1", "item2", "item3", "item4"),
                     exclusions = c("item2, item3", NA, NA, NA))

# Create tuples
itemTuples(items = items, idCol = "ID", infoCol = 2,
                    sepPattern = ", ")
#>      [,1]    [,2]   
#> [1,] "item1" "item2"
#> [2,] "item1" "item3"

```
