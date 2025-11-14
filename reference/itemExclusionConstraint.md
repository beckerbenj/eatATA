# Create item inclusion or exclusion constraints.

Create constraints that prohibit that item pairs occur in the same test
forms (exclusions) or force item pairs to be in the same test forms
(inclusions).

## Usage

``` r
itemExclusionConstraint(
  nForms,
  itemTuples,
  itemIDs,
  whichForms = seq_len(nForms),
  info_text = NULL
)

itemInclusionConstraint(
  nForms,
  itemTuples,
  itemIDs,
  whichForms = seq_len(nForms),
  info_text = NULL
)
```

## Arguments

- nForms:

  Number of forms to be created.

- itemTuples:

  `data.frame` or `matrix` with two columns, containing tuples with item
  IDs indicating, which items should be in test forms inclusively or
  exclusively.

- itemIDs:

  Character vector of item IDs in correct ordering.

- whichForms:

  An integer vector indicating which test forms should be constrained.
  Defaults to all the test forms.

- info_text:

  a character string of length 1, to be used in the `"info"`-attribute
  of the resulting `constraint`-object.

## Value

An object of class `"constraint"`.

## Details

Item tuples can, for example, be created by the functions
[`itemTuples`](https://beckerbenj.github.io/eatATA/reference/itemTuples.md),
[`matrixExclusionTuples`](https://beckerbenj.github.io/eatATA/reference/matrixExclusionTuples.md)
and
[`stemInclusionTuples`](https://beckerbenj.github.io/eatATA/reference/stemInclusionTuples.md).

## Functions

- `itemExclusionConstraint()`: item pair exclusion constraints

- `itemInclusionConstraint()`: item pair inclusion constraints

## Examples

``` r
## Simple Exclusion Example
# item-IDs
IDs <- c("item1", "item2", "item3", "item4")

# exclusion tuples: Item 1 can not be in the test form as item 2 and 3
exTuples <- data.frame(v1 = c("item1", "item1"), v2 = c("item2", "item3"),
                       stringsAsFactors = FALSE)
# inclusion tuples: Items 2 and 3 have to be in the same test form
inTuples <- data.frame(v1 = c("item2"), v2 = c("item3"),
                       stringsAsFactors = FALSE)

# create constraints
itemExclusionConstraint(nForms = 2, itemTuples = exTuples, itemIDs = IDs)
#> $A_binary
#> 4 x 8 sparse Matrix of class "dgCMatrix"
#>                     
#> [1,] 1 1 0 0 . . . .
#> [2,] . . . . 1 1 0 0
#> [3,] 1 0 1 0 . . . .
#> [4,] . . . . 1 0 1 0
#> 
#> $A_real
#> NULL
#> 
#> $operators
#> [1] "<=" "<=" "<=" "<="
#> 
#> $d
#> [1] 1 1 1 1
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
#>   rowNr formNr itemNr           constraint
#> 1     1      1     NA item1_excludes_item2
#> 2     2      2     NA item1_excludes_item2
#> 3     3      1     NA item1_excludes_item3
#> 4     4      2     NA item1_excludes_item3
#> attr(,"itemIDs")
#> [1] "item1" "item2" "item3" "item4"
itemInclusionConstraint(nForms = 2, itemTuples = inTuples, itemIDs = IDs)
#> $A_binary
#> 2 x 8 sparse Matrix of class "dgCMatrix"
#>                       
#> [1,] 0 1 -1 0 . .  . .
#> [2,] . .  . . 0 1 -1 0
#> 
#> $A_real
#> NULL
#> 
#> $operators
#> [1] "=" "="
#> 
#> $d
#> [1] 0 0
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
#>   rowNr formNr itemNr           constraint
#> 1     1      1     NA item2_includes_item3
#> 2     2      2     NA item2_includes_item3
#> attr(,"itemIDs")
#> [1] "item1" "item2" "item3" "item4"


########
## Full workflow for exclusions using itemTuples
# Example data.frame
items <- data.frame(ID = c("item1", "item2", "item3", "item4"),
                     infoCol = c("item2, item3", NA, NA, NA))

# Create tuples
exTuples2 <- itemTuples(items = items, idCol = "ID", infoCol = "infoCol",
                    sepPattern = ", ")

## Create constraints
itemExclusionConstraint(nForms = 2, itemTuples = exTuples2, itemIDs = IDs)
#> $A_binary
#> 4 x 8 sparse Matrix of class "dgCMatrix"
#>                     
#> [1,] 1 1 0 0 . . . .
#> [2,] . . . . 1 1 0 0
#> [3,] 1 0 1 0 . . . .
#> [4,] . . . . 1 0 1 0
#> 
#> $A_real
#> NULL
#> 
#> $operators
#> [1] "<=" "<=" "<=" "<="
#> 
#> $d
#> [1] 1 1 1 1
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
#>   rowNr formNr itemNr           constraint
#> 1     1      1     NA item1_excludes_item2
#> 2     2      2     NA item1_excludes_item2
#> 3     3      1     NA item1_excludes_item3
#> 4     4      2     NA item1_excludes_item3
#> attr(,"itemIDs")
#> [1] "item1" "item2" "item3" "item4"
```
