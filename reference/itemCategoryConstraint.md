# Create item category constraints.

Create constraints related to item categories/groupings (as represented
by `itemCategories`). That is, the created constraints assure that the
number of items of each category per test form is either (a) smaller or
equal than (`operator = "<="`), (b) equal to (`operator = "="`), or (c)
greater than or equal to (`operator = ">="`) the corresponding
`targetValues`.

## Usage

``` r
itemCategoryConstraint(
  nForms,
  itemCategories,
  operator = c("<=", "=", ">="),
  targetValues,
  whichForms = seq_len(nForms),
  info_text = NULL,
  itemIDs = names(itemCategories)
)
```

## Arguments

- nForms:

  Number of forms to be created.

- itemCategories:

  a factor representing the categories/grouping of the items

- operator:

  A character indicating which operator should be used in the
  constraints, with three possible values: `"<="`, `"="`, or `">="`. See
  details for more information.

- targetValues:

  an integer vector representing the target number per category. The
  order of the target values should correspond with the order of the
  levels of the factor in `itemCategory`.

- whichForms:

  An integer vector indicating which test forms should be constrained.
  Defaults to all the test forms.

- info_text:

  a character string of length 1, to be used in the `"info"`-attribute
  of the resulting `constraint`-object.

- itemIDs:

  a character vector of item IDs in correct ordering, or NULL.

## Value

A object of class `"constraint"`.

## Examples

``` r
## constraints to make sure that there are at least 3 items of each item type
## in each test form
nItems <- 30
item_type <- factor(sample(1:3, size = nItems, replace = TRUE))
itemCategoryConstraint(2, item_type, ">=", targetValues = c(1, 3, 2))
#> Warning: Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.
#> Warning: Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.
#> Warning: Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.
#> $A_binary
#> 6 x 60 sparse Matrix of class "dgCMatrix"
#>                                                                               
#> [1,] 0 1 0 0 0 0 0 1 0 0 0 1 1 0 0 0 0 1 0 1 0 0 0 1 0 0 0 0 0 0 . . . . . . .
#> [2,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 0 1 0 0 0 0 0
#> [3,] 1 0 1 0 0 0 0 0 0 1 0 0 0 1 1 1 1 0 1 0 0 0 1 0 1 1 1 0 0 0 . . . . . . .
#> [4,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 0 1 0 0 0 0
#> [5,] 0 0 0 1 1 1 1 0 1 0 1 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 1 1 1 . . . . . . .
#> [6,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 0 0 0 1 1 1 1
#>                                                   
#> [1,] . . . . . . . . . . . . . . . . . . . . . . .
#> [2,] 1 0 0 0 1 1 0 0 0 0 1 0 1 0 0 0 1 0 0 0 0 0 0
#> [3,] . . . . . . . . . . . . . . . . . . . . . . .
#> [4,] 0 0 1 0 0 0 1 1 1 1 0 1 0 0 0 1 0 1 1 1 0 0 0
#> [5,] . . . . . . . . . . . . . . . . . . . . . . .
#> [6,] 0 1 0 1 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 1 1 1
#> 
#> $A_real
#> NULL
#> 
#> $operators
#> [1] ">=" ">=" ">=" ">=" ">=" ">="
#> 
#> $d
#> [1] 1 1 3 3 2 2
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
#> [1] 30
#> attr(,"info")
#>   rowNr formNr itemNr   constraint
#> 1     1      1     NA item_type>=1
#> 2     2      2     NA item_type>=1
#> 3     3      1     NA item_type>=3
#> 4     4      2     NA item_type>=3
#> 5     5      1     NA item_type>=2
#> 6     6      2     NA item_type>=2
#> attr(,"itemIDs")
#>  [1] "it01" "it02" "it03" "it04" "it05" "it06" "it07" "it08" "it09" "it10"
#> [11] "it11" "it12" "it13" "it14" "it15" "it16" "it17" "it18" "it19" "it20"
#> [21] "it21" "it22" "it23" "it24" "it25" "it26" "it27" "it28" "it29" "it30"
```
