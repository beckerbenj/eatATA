# Create item inclusion tuples from item stem.

If item-stimulus hierarchies are stored in a single stimulus column,
`stemInclusionTuples` transforms this format into item pairs ('tuples').

## Usage

``` r
stemInclusionTuples(items, idCol = "ID", stemCol)
```

## Arguments

- items:

  A `data.frame` with information on an item pool.

- idCol:

  character or integer indicating the item ID column in `items`.

- stemCol:

  A column in `items` containing the item stems or stimulus names,
  shared among items which should be in the same test form.

## Value

A `data.frame` with two columns.

## Details

Inclusion tuples can be used by
[`itemInclusionConstraint`](https://beckerbenj.github.io/eatATA/reference/itemExclusionConstraint.md)
to set up inclusion constraints.

## Examples

``` r
# Example data.frame
inclDF <- data.frame(ID = paste0("item_", 1:6),
          stem = c(rep("stim_1", 3), "stim_3", "stim_4", "stim_3"),
          stringsAsFactors = FALSE)

# Create tuples
stemInclusionTuples(inclDF, idCol = "ID", stemCol = "stem")
#>      [,1]     [,2]    
#> [1,] "item_1" "item_2"
#> [2,] "item_1" "item_3"
#> [3,] "item_2" "item_3"
#> [4,] "item_4" "item_6"

```
