# Create item category constraints with minimum and maximum.

`itemCategoriesRange`, `itemCategoriesMin`, and `itemCategoriesMax`
create constraints related to item categories/groupings (as represented
by `itemCategories`). That is, the created constraints assure that the
number of items of each category per test form is either smaller or
equal than the specified `max`, greater than or equal to `min` or both
`range`.

## Usage

``` r
itemCategoryRangeConstraint(
  nForms,
  itemCategories,
  range,
  whichForms = seq_len(nForms),
  info_text = NULL,
  itemIDs = names(itemCategories)
)

itemCategoryMinConstraint(
  nForms,
  itemCategories,
  min,
  whichForms = seq_len(nForms),
  info_text = NULL,
  itemIDs = names(itemCategories)
)

itemCategoryMaxConstraint(
  nForms,
  itemCategories,
  max,
  whichForms = seq_len(nForms),
  info_text = NULL,
  itemIDs = names(itemCategories)
)

itemCategoryDeviationConstraint(
  nForms,
  itemCategories,
  targetValues,
  allowedDeviation,
  relative = FALSE,
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

- range:

  a matrix with two columns representing the the minimal and the maximum
  frequency of the items from each level/category `itemCategories`

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

- targetValues:

  an integer vector representing the target number per category. The
  order of the target values should correspond with the order of the
  levels of the factor in `itemCategory`.

- allowedDeviation:

  the maximum allowed deviation from the `targetValue`

- relative:

  a logical expressing whether or not the `allowedDeviation` should be
  interpreted as a proportion of the `targetValue`

## Value

A sparse matrix.

## Details

`itemCategoriesDeviation` also constrains the minimal and the maximal
value of the number of items of each category per test form, but based
on chosen `targetValues`, and maximal allowed deviations (i.e.,
`allowedDeviation`) from those `targetValues`.

## Functions

- `itemCategoryMinConstraint()`: constrain minimum value

- `itemCategoryMaxConstraint()`: constrain maximum value

- `itemCategoryDeviationConstraint()`: constrain the distance form the
  `targetValues`

## Examples

``` r
## constraints to make sure that there are at least 2 and maximally 4
##  items of each item type in each test form
nItems <- 30
item_type <- factor(sample(1:3, size = nItems, replace = TRUE))
itemCategoryRangeConstraint(2, item_type,
                            range = cbind(min = rep(2, 3), max = rep(4, 3)))
#> Warning: Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.
#> Warning: Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.
#> Warning: Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.
#> Warning: Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.
#> Warning: Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.
#> Warning: Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.
#> $A_binary
#> 12 x 60 sparse Matrix of class "dgCMatrix"
#>                                                                                
#>  [1,] 0 0 0 0 0 1 0 0 0 0 0 1 1 1 0 1 0 1 0 0 0 0 0 0 0 0 1 1 0 0 . . . . . . .
#>  [2,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 0 0 0 0 0 1 0
#>  [3,] 0 1 0 1 1 0 1 1 0 1 0 0 0 0 1 0 0 0 1 1 0 0 1 0 1 0 0 0 0 1 . . . . . . .
#>  [4,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 0 1 0 1 1 0 1
#>  [5,] 1 0 1 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0 0 0 1 1 0 1 0 1 0 0 1 0 . . . . . . .
#>  [6,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 0 1 0 0 0 0
#>  [7,] 0 0 0 0 0 1 0 0 0 0 0 1 1 1 0 1 0 1 0 0 0 0 0 0 0 0 1 1 0 0 . . . . . . .
#>  [8,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 0 0 0 0 0 1 0
#>  [9,] 0 1 0 1 1 0 1 1 0 1 0 0 0 0 1 0 0 0 1 1 0 0 1 0 1 0 0 0 0 1 . . . . . . .
#> [10,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 0 1 0 1 1 0 1
#> [11,] 1 0 1 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0 0 0 1 1 0 1 0 1 0 0 1 0 . . . . . . .
#> [12,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 0 1 0 0 0 0
#>                                                    
#>  [1,] . . . . . . . . . . . . . . . . . . . . . . .
#>  [2,] 0 0 0 0 1 1 1 0 1 0 1 0 0 0 0 0 0 0 0 1 1 0 0
#>  [3,] . . . . . . . . . . . . . . . . . . . . . . .
#>  [4,] 1 0 1 0 0 0 0 1 0 0 0 1 1 0 0 1 0 1 0 0 0 0 1
#>  [5,] . . . . . . . . . . . . . . . . . . . . . . .
#>  [6,] 0 1 0 1 0 0 0 0 0 1 0 0 0 1 1 0 1 0 1 0 0 1 0
#>  [7,] . . . . . . . . . . . . . . . . . . . . . . .
#>  [8,] 0 0 0 0 1 1 1 0 1 0 1 0 0 0 0 0 0 0 0 1 1 0 0
#>  [9,] . . . . . . . . . . . . . . . . . . . . . . .
#> [10,] 1 0 1 0 0 0 0 1 0 0 0 1 1 0 0 1 0 1 0 0 0 0 1
#> [11,] . . . . . . . . . . . . . . . . . . . . . . .
#> [12,] 0 1 0 1 0 0 0 0 0 1 0 0 0 1 1 0 1 0 1 0 0 1 0
#> 
#> $A_real
#> NULL
#> 
#> $operators
#>  [1] ">=" ">=" ">=" ">=" ">=" ">=" "<=" "<=" "<=" "<=" "<=" "<="
#> 
#> $d
#>  [1] 2 2 2 2 2 2 4 4 4 4 4 4
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
#>    rowNr formNr itemNr   constraint
#> 1      1      1     NA item_type>=2
#> 2      2      2     NA item_type>=2
#> 3      3      1     NA item_type>=2
#> 4      4      2     NA item_type>=2
#> 5      5      1     NA item_type>=2
#> 6      6      2     NA item_type>=2
#> 7      7      1     NA item_type<=4
#> 8      8      2     NA item_type<=4
#> 9      9      1     NA item_type<=4
#> 10    10      2     NA item_type<=4
#> 11    11      1     NA item_type<=4
#> 12    12      2     NA item_type<=4
#> attr(,"itemIDs")
#>  [1] "it01" "it02" "it03" "it04" "it05" "it06" "it07" "it08" "it09" "it10"
#> [11] "it11" "it12" "it13" "it14" "it15" "it16" "it17" "it18" "it19" "it20"
#> [21] "it21" "it22" "it23" "it24" "it25" "it26" "it27" "it28" "it29" "it30"

## or alternatively
itemCategoryDeviationConstraint(2, item_type,
                                targetValues = rep(3, 3),
                                allowedDeviation = rep(4, 3))
#> Warning: Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.
#> Warning: Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.
#> Warning: Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.
#> Warning: Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.
#> Warning: Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.
#> Warning: Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.
#> $A_binary
#> 12 x 60 sparse Matrix of class "dgCMatrix"
#>                                                                                
#>  [1,] 0 0 0 0 0 1 0 0 0 0 0 1 1 1 0 1 0 1 0 0 0 0 0 0 0 0 1 1 0 0 . . . . . . .
#>  [2,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 0 0 0 0 0 1 0
#>  [3,] 0 1 0 1 1 0 1 1 0 1 0 0 0 0 1 0 0 0 1 1 0 0 1 0 1 0 0 0 0 1 . . . . . . .
#>  [4,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 0 1 0 1 1 0 1
#>  [5,] 1 0 1 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0 0 0 1 1 0 1 0 1 0 0 1 0 . . . . . . .
#>  [6,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 0 1 0 0 0 0
#>  [7,] 0 0 0 0 0 1 0 0 0 0 0 1 1 1 0 1 0 1 0 0 0 0 0 0 0 0 1 1 0 0 . . . . . . .
#>  [8,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 0 0 0 0 0 1 0
#>  [9,] 0 1 0 1 1 0 1 1 0 1 0 0 0 0 1 0 0 0 1 1 0 0 1 0 1 0 0 0 0 1 . . . . . . .
#> [10,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 0 1 0 1 1 0 1
#> [11,] 1 0 1 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0 0 0 1 1 0 1 0 1 0 0 1 0 . . . . . . .
#> [12,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1 0 1 0 0 0 0
#>                                                    
#>  [1,] . . . . . . . . . . . . . . . . . . . . . . .
#>  [2,] 0 0 0 0 1 1 1 0 1 0 1 0 0 0 0 0 0 0 0 1 1 0 0
#>  [3,] . . . . . . . . . . . . . . . . . . . . . . .
#>  [4,] 1 0 1 0 0 0 0 1 0 0 0 1 1 0 0 1 0 1 0 0 0 0 1
#>  [5,] . . . . . . . . . . . . . . . . . . . . . . .
#>  [6,] 0 1 0 1 0 0 0 0 0 1 0 0 0 1 1 0 1 0 1 0 0 1 0
#>  [7,] . . . . . . . . . . . . . . . . . . . . . . .
#>  [8,] 0 0 0 0 1 1 1 0 1 0 1 0 0 0 0 0 0 0 0 1 1 0 0
#>  [9,] . . . . . . . . . . . . . . . . . . . . . . .
#> [10,] 1 0 1 0 0 0 0 1 0 0 0 1 1 0 0 1 0 1 0 0 0 0 1
#> [11,] . . . . . . . . . . . . . . . . . . . . . . .
#> [12,] 0 1 0 1 0 0 0 0 0 1 0 0 0 1 1 0 1 0 1 0 0 1 0
#> 
#> $A_real
#> NULL
#> 
#> $operators
#>  [1] ">=" ">=" ">=" ">=" ">=" ">=" "<=" "<=" "<=" "<=" "<=" "<="
#> 
#> $d
#>  [1] -1 -1 -1 -1 -1 -1  7  7  7  7  7  7
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
#>    rowNr formNr itemNr    constraint
#> 1      1      1     NA item_type>=-1
#> 2      2      2     NA item_type>=-1
#> 3      3      1     NA item_type>=-1
#> 4      4      2     NA item_type>=-1
#> 5      5      1     NA item_type>=-1
#> 6      6      2     NA item_type>=-1
#> 7      7      1     NA  item_type<=7
#> 8      8      2     NA  item_type<=7
#> 9      9      1     NA  item_type<=7
#> 10    10      2     NA  item_type<=7
#> 11    11      1     NA  item_type<=7
#> 12    12      2     NA  item_type<=7
#> attr(,"itemIDs")
#>  [1] "it01" "it02" "it03" "it04" "it05" "it06" "it07" "it08" "it09" "it10"
#> [11] "it11" "it12" "it13" "it14" "it15" "it16" "it17" "it18" "it19" "it20"
#> [21] "it21" "it22" "it23" "it24" "it25" "it26" "it27" "it28" "it29" "it30"
```
