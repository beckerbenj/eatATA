# Compute target values based on the item pool.

Compute target values for item values/categories based on the number of
items in the item pool, the number of test forms to assemble and the
number of items in each test form (i.e., test length).

## Usage

``` r
computeTargetValues(
  itemValues,
  nForms,
  testLength = NULL,
  allowedDeviation = NULL,
  relative = FALSE
)

# Default S3 method
computeTargetValues(
  itemValues,
  nForms,
  testLength = NULL,
  allowedDeviation = NULL,
  relative = FALSE
)

# S3 method for class 'factor'
computeTargetValues(
  itemValues,
  nForms,
  testLength = NULL,
  allowedDeviation = NULL,
  relative = FALSE
)
```

## Arguments

- itemValues:

  Item parameter/values for which the sum per test form should be
  constrained.

- nForms:

  Number of forms to be created.

- testLength:

  to be documented.

- allowedDeviation:

  Numeric value of length 1. How much deviance is allowed from target
  values?

- relative:

  Is the `allowedDeviation` expressed as a proportion?

## Value

a vector or a matrix with target values (see details)

## Details

Both for numerical and categorical item values, the target values are
the item pool average scaled by the ratio of items in the forms and
items in the item pool. The behavior of the function changes depending
on the class of `itemValues`.

When `itemValues` is a numerical vector, an when `allowedDeviation` is
`NULL` (the default), only one target value is computed. This value
could be used in the `targetConstraint`-function. Otherwise (i.e.,
`allowedDeviation` is a numerical value), the target is computed, but a
minimal and a maximal (target)value are returned, based on the allowed
deviation. When `relative == TRUE` the allowed deviation should be
expressed as a proportion. In that case the minimal and maximal values
are a computed proportionally.

When `itemValues` is a `factor`, it is assumed that the item values are
item categories, and hence only whole valued frequencies are returned.
To be more precise, a matrix with the minimal and maximal target
frequencies for every level of the factor are returned. When
`allowedDeviation` is `NULL`, the difference between the minimal and
maximal value is one (or zero). As a consequence, dummy-item values are
best specified as a factor (see examples).

## Methods (by class)

- `computeTargetValues(default)`: compute target values

- `computeTargetValues(factor)`: compute target frequencies for item
  categories

## Examples

``` r
## Assume an item pool with 50 items with random item information values (iif) for
## a given ability value.
set.seed(50)
itemInformations <- runif(50, 0.5, 3)

## The target value for the test information value (i.e., sum of the item
## informations) when three test forms of 10 items are assembled is:
computeTargetValues(itemInformations, nForms = 3, testLength = 10)
#> [1] 16.18879

## The minimum and maximum test iformation values for an allowed deviation of
## 10 percent are:
computeTargetValues(itemInformations, nForms = 3, allowedDeviation = .10,
   relative = TRUE, testLength = 10)
#>      min      max 
#> 14.56991 17.80767 


## items_vera$MC is dummy variable indication which items in the pool are multiple choise
str(items_vera$MC)
#>  num [1:80] 0 0 0 0 0 0 0 0 0 1 ...

## when used as a numerical vector, the dummy is not treated as a categorical
## indicator, but rather as a numerical value.
computeTargetValues(items_vera$MC, nForms = 14)
#> [1] 1.5
computeTargetValues(items_vera$MC, nForms = 14, allowedDeviation = 1)
#> min max 
#> 0.5 2.5 

## Therefore, it is best to convert dummy variables into a factor, so that
## automatically freqyencies are returned
MC_factor <- factor(items_vera$MC, labels = c("not MC", "MC"))
computeTargetValues(MC_factor, nForms = 14)
#>        min max
#> not MC   4   5
#> MC       1   2
computeTargetValues(MC_factor, nForms = 3)
#>        min max
#> not MC  19  20
#> MC       7   7

## The computed minimum and maximum frequencies can be used to create contstraints.
MC_ranges <- computeTargetValues(MC_factor, nForms = 3)
itemCategoryRangeConstraint(3, MC_factor, range = MC_ranges)
#> Warning: Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.
#> Warning: Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.
#> Warning: Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.
#> Warning: Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.
#> $A_binary
#> 12 x 240 sparse Matrix of class "dgCMatrix"
#>                                                                                
#>  [1,] 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 0 1 1 0 1 1 0 0 0 1 1 0 1 1 1 0 1 1 1 1 1 1
#>  [2,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [3,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [4,] 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 1 0 0 1 1 1 0 0 1 0 0 0 1 0 0 0 0 0 0
#>  [5,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [6,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [7,] 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 0 1 1 0 1 1 0 0 0 1 1 0 1 1 1 0 1 1 1 1 1 1
#>  [8,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [9,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#> [10,] 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 1 0 0 1 1 1 0 0 1 0 0 0 1 0 0 0 0 0 0
#> [11,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#> [12,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>                                                                                
#>  [1,] 1 1 1 1 0 0 1 1 1 1 1 0 1 0 0 0 1 1 0 0 1 0 1 0 1 1 0 1 1 1 1 1 1 1 1 0 1
#>  [2,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [3,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [4,] 0 0 0 0 1 1 0 0 0 0 0 1 0 1 1 1 0 0 1 1 0 1 0 1 0 0 1 0 0 0 0 0 0 0 0 1 0
#>  [5,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [6,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [7,] 1 1 1 1 0 0 1 1 1 1 1 0 1 0 0 0 1 1 0 0 1 0 1 0 1 1 0 1 1 1 1 1 1 1 1 0 1
#>  [8,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [9,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#> [10,] 0 0 0 0 1 1 0 0 0 0 0 1 0 1 1 1 0 0 1 1 0 1 0 1 0 0 1 0 0 0 0 0 0 0 0 1 0
#> [11,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#> [12,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>                                                                                
#>  [1,] 0 1 1 1 1 1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [2,] . . . . . . 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 0 1 1 0 1 1 0 0 0 1 1 0 1 1 1 0
#>  [3,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [4,] 1 0 0 0 0 0 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [5,] . . . . . . 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 1 0 0 1 1 1 0 0 1 0 0 0 1
#>  [6,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [7,] 0 1 1 1 1 1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [8,] . . . . . . 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 0 1 1 0 1 1 0 0 0 1 1 0 1 1 1 0
#>  [9,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#> [10,] 1 0 0 0 0 0 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#> [11,] . . . . . . 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 1 0 0 1 1 1 0 0 1 0 0 0 1
#> [12,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>                                                                                
#>  [1,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [2,] 1 1 1 1 1 1 1 1 1 1 0 0 1 1 1 1 1 0 1 0 0 0 1 1 0 0 1 0 1 0 1 1 0 1 1 1 1
#>  [3,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [4,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [5,] 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 1 0 1 1 1 0 0 1 1 0 1 0 1 0 0 1 0 0 0 0
#>  [6,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [7,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [8,] 1 1 1 1 1 1 1 1 1 1 0 0 1 1 1 1 1 0 1 0 0 0 1 1 0 0 1 0 1 0 1 1 0 1 1 1 1
#>  [9,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#> [10,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#> [11,] 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 1 0 1 1 1 0 0 1 1 0 1 0 1 0 0 1 0 0 0 0
#> [12,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>                                                                                
#>  [1,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [2,] 1 1 1 1 0 1 0 1 1 1 1 1 . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [3,] . . . . . . . . . . . . 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 0 1 1 0 1 1 0 0 0 1
#>  [4,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [5,] 0 0 0 0 1 0 1 0 0 0 0 0 . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [6,] . . . . . . . . . . . . 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 1 0 0 1 1 1 0
#>  [7,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [8,] 1 1 1 1 0 1 0 1 1 1 1 1 . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [9,] . . . . . . . . . . . . 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 0 1 1 0 1 1 0 0 0 1
#> [10,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#> [11,] 0 0 0 0 1 0 1 0 0 0 0 0 . . . . . . . . . . . . . . . . . . . . . . . . .
#> [12,] . . . . . . . . . . . . 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 1 0 0 1 1 1 0
#>                                                                                
#>  [1,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [2,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [3,] 1 0 1 1 1 0 1 1 1 1 1 1 1 1 1 1 0 0 1 1 1 1 1 0 1 0 0 0 1 1 0 0 1 0 1 0 1
#>  [4,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [5,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [6,] 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 1 0 1 1 1 0 0 1 1 0 1 0 1 0
#>  [7,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [8,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [9,] 1 0 1 1 1 0 1 1 1 1 1 1 1 1 1 1 0 0 1 1 1 1 1 0 1 0 0 0 1 1 0 0 1 0 1 0 1
#> [10,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#> [11,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#> [12,] 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 1 0 1 1 1 0 0 1 1 0 1 0 1 0
#>                                          
#>  [1,] . . . . . . . . . . . . . . . . . .
#>  [2,] . . . . . . . . . . . . . . . . . .
#>  [3,] 1 0 1 1 1 1 1 1 1 1 0 1 0 1 1 1 1 1
#>  [4,] . . . . . . . . . . . . . . . . . .
#>  [5,] . . . . . . . . . . . . . . . . . .
#>  [6,] 0 1 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0
#>  [7,] . . . . . . . . . . . . . . . . . .
#>  [8,] . . . . . . . . . . . . . . . . . .
#>  [9,] 1 0 1 1 1 1 1 1 1 1 0 1 0 1 1 1 1 1
#> [10,] . . . . . . . . . . . . . . . . . .
#> [11,] . . . . . . . . . . . . . . . . . .
#> [12,] 0 1 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0
#> 
#> $A_real
#> NULL
#> 
#> $operators
#>  [1] ">=" ">=" ">=" ">=" ">=" ">=" "<=" "<=" "<=" "<=" "<=" "<="
#> 
#> $d
#> not MC not MC not MC     MC     MC     MC not MC not MC not MC     MC     MC 
#>     19     19     19      7      7      7     20     20     20      7      7 
#>     MC 
#>      7 
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
#> [1] 80
#> attr(,"info")
#>    rowNr formNr itemNr    constraint
#> 1      1      1     NA MC_factor>=19
#> 2      2      2     NA MC_factor>=19
#> 3      3      3     NA MC_factor>=19
#> 4      4      1     NA  MC_factor>=7
#> 5      5      2     NA  MC_factor>=7
#> 6      6      3     NA  MC_factor>=7
#> 7      7      1     NA MC_factor<=20
#> 8      8      2     NA MC_factor<=20
#> 9      9      3     NA MC_factor<=20
#> 10    10      1     NA  MC_factor<=7
#> 11    11      2     NA  MC_factor<=7
#> 12    12      3     NA  MC_factor<=7
#> attr(,"itemIDs")
#>  [1] "it01" "it02" "it03" "it04" "it05" "it06" "it07" "it08" "it09" "it10"
#> [11] "it11" "it12" "it13" "it14" "it15" "it16" "it17" "it18" "it19" "it20"
#> [21] "it21" "it22" "it23" "it24" "it25" "it26" "it27" "it28" "it29" "it30"
#> [31] "it31" "it32" "it33" "it34" "it35" "it36" "it37" "it38" "it39" "it40"
#> [41] "it41" "it42" "it43" "it44" "it45" "it46" "it47" "it48" "it49" "it50"
#> [51] "it51" "it52" "it53" "it54" "it55" "it56" "it57" "it58" "it59" "it60"
#> [61] "it61" "it62" "it63" "it64" "it65" "it66" "it67" "it68" "it69" "it70"
#> [71] "it71" "it72" "it73" "it74" "it75" "it76" "it77" "it78" "it79" "it80"

## When desired, the automatically computed range can be adjusted by hand. This
##  can be of use when only a limited set of the categories should be constrained.
##  For instance, when only the multiple-choice items should be constrained, and
##  the non-multiple-choice items should not be constrained, the minimum and
##  maximum value can be set to a very small and a very high value, respectively.
##  Or to other sensible values.
MC_ranges["not MC", ] <- c(0, 40)
MC_ranges
#>        min max
#> not MC   0  40
#> MC       7   7
itemCategoryRangeConstraint(3, MC_factor, range = MC_ranges)
#> Warning: Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.
#> Warning: Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.
#> Warning: Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.
#> Warning: Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.
#> $A_binary
#> 12 x 240 sparse Matrix of class "dgCMatrix"
#>                                                                                
#>  [1,] 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 0 1 1 0 1 1 0 0 0 1 1 0 1 1 1 0 1 1 1 1 1 1
#>  [2,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [3,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [4,] 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 1 0 0 1 1 1 0 0 1 0 0 0 1 0 0 0 0 0 0
#>  [5,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [6,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [7,] 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 0 1 1 0 1 1 0 0 0 1 1 0 1 1 1 0 1 1 1 1 1 1
#>  [8,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [9,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#> [10,] 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 1 0 0 1 1 1 0 0 1 0 0 0 1 0 0 0 0 0 0
#> [11,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#> [12,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>                                                                                
#>  [1,] 1 1 1 1 0 0 1 1 1 1 1 0 1 0 0 0 1 1 0 0 1 0 1 0 1 1 0 1 1 1 1 1 1 1 1 0 1
#>  [2,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [3,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [4,] 0 0 0 0 1 1 0 0 0 0 0 1 0 1 1 1 0 0 1 1 0 1 0 1 0 0 1 0 0 0 0 0 0 0 0 1 0
#>  [5,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [6,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [7,] 1 1 1 1 0 0 1 1 1 1 1 0 1 0 0 0 1 1 0 0 1 0 1 0 1 1 0 1 1 1 1 1 1 1 1 0 1
#>  [8,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [9,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#> [10,] 0 0 0 0 1 1 0 0 0 0 0 1 0 1 1 1 0 0 1 1 0 1 0 1 0 0 1 0 0 0 0 0 0 0 0 1 0
#> [11,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#> [12,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>                                                                                
#>  [1,] 0 1 1 1 1 1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [2,] . . . . . . 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 0 1 1 0 1 1 0 0 0 1 1 0 1 1 1 0
#>  [3,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [4,] 1 0 0 0 0 0 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [5,] . . . . . . 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 1 0 0 1 1 1 0 0 1 0 0 0 1
#>  [6,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [7,] 0 1 1 1 1 1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [8,] . . . . . . 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 0 1 1 0 1 1 0 0 0 1 1 0 1 1 1 0
#>  [9,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#> [10,] 1 0 0 0 0 0 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#> [11,] . . . . . . 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 1 0 0 1 1 1 0 0 1 0 0 0 1
#> [12,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>                                                                                
#>  [1,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [2,] 1 1 1 1 1 1 1 1 1 1 0 0 1 1 1 1 1 0 1 0 0 0 1 1 0 0 1 0 1 0 1 1 0 1 1 1 1
#>  [3,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [4,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [5,] 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 1 0 1 1 1 0 0 1 1 0 1 0 1 0 0 1 0 0 0 0
#>  [6,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [7,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [8,] 1 1 1 1 1 1 1 1 1 1 0 0 1 1 1 1 1 0 1 0 0 0 1 1 0 0 1 0 1 0 1 1 0 1 1 1 1
#>  [9,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#> [10,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#> [11,] 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 1 0 1 1 1 0 0 1 1 0 1 0 1 0 0 1 0 0 0 0
#> [12,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>                                                                                
#>  [1,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [2,] 1 1 1 1 0 1 0 1 1 1 1 1 . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [3,] . . . . . . . . . . . . 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 0 1 1 0 1 1 0 0 0 1
#>  [4,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [5,] 0 0 0 0 1 0 1 0 0 0 0 0 . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [6,] . . . . . . . . . . . . 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 1 0 0 1 1 1 0
#>  [7,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [8,] 1 1 1 1 0 1 0 1 1 1 1 1 . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [9,] . . . . . . . . . . . . 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 0 1 1 0 1 1 0 0 0 1
#> [10,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#> [11,] 0 0 0 0 1 0 1 0 0 0 0 0 . . . . . . . . . . . . . . . . . . . . . . . . .
#> [12,] . . . . . . . . . . . . 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 1 0 0 1 1 1 0
#>                                                                                
#>  [1,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [2,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [3,] 1 0 1 1 1 0 1 1 1 1 1 1 1 1 1 1 0 0 1 1 1 1 1 0 1 0 0 0 1 1 0 0 1 0 1 0 1
#>  [4,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [5,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [6,] 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 1 0 1 1 1 0 0 1 1 0 1 0 1 0
#>  [7,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [8,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#>  [9,] 1 0 1 1 1 0 1 1 1 1 1 1 1 1 1 1 0 0 1 1 1 1 1 0 1 0 0 0 1 1 0 0 1 0 1 0 1
#> [10,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#> [11,] . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
#> [12,] 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 1 0 1 1 1 0 0 1 1 0 1 0 1 0
#>                                          
#>  [1,] . . . . . . . . . . . . . . . . . .
#>  [2,] . . . . . . . . . . . . . . . . . .
#>  [3,] 1 0 1 1 1 1 1 1 1 1 0 1 0 1 1 1 1 1
#>  [4,] . . . . . . . . . . . . . . . . . .
#>  [5,] . . . . . . . . . . . . . . . . . .
#>  [6,] 0 1 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0
#>  [7,] . . . . . . . . . . . . . . . . . .
#>  [8,] . . . . . . . . . . . . . . . . . .
#>  [9,] 1 0 1 1 1 1 1 1 1 1 0 1 0 1 1 1 1 1
#> [10,] . . . . . . . . . . . . . . . . . .
#> [11,] . . . . . . . . . . . . . . . . . .
#> [12,] 0 1 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0
#> 
#> $A_real
#> NULL
#> 
#> $operators
#>  [1] ">=" ">=" ">=" ">=" ">=" ">=" "<=" "<=" "<=" "<=" "<=" "<="
#> 
#> $d
#> not MC not MC not MC     MC     MC     MC not MC not MC not MC     MC     MC 
#>      0      0      0      7      7      7     40     40     40      7      7 
#>     MC 
#>      7 
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
#> [1] 80
#> attr(,"info")
#>    rowNr formNr itemNr    constraint
#> 1      1      1     NA  MC_factor>=0
#> 2      2      2     NA  MC_factor>=0
#> 3      3      3     NA  MC_factor>=0
#> 4      4      1     NA  MC_factor>=7
#> 5      5      2     NA  MC_factor>=7
#> 6      6      3     NA  MC_factor>=7
#> 7      7      1     NA MC_factor<=40
#> 8      8      2     NA MC_factor<=40
#> 9      9      3     NA MC_factor<=40
#> 10    10      1     NA  MC_factor<=7
#> 11    11      2     NA  MC_factor<=7
#> 12    12      3     NA  MC_factor<=7
#> attr(,"itemIDs")
#>  [1] "it01" "it02" "it03" "it04" "it05" "it06" "it07" "it08" "it09" "it10"
#> [11] "it11" "it12" "it13" "it14" "it15" "it16" "it17" "it18" "it19" "it20"
#> [21] "it21" "it22" "it23" "it24" "it25" "it26" "it27" "it28" "it29" "it30"
#> [31] "it31" "it32" "it33" "it34" "it35" "it36" "it37" "it38" "it39" "it40"
#> [41] "it41" "it42" "it43" "it44" "it45" "it46" "it47" "it48" "it49" "it50"
#> [51] "it51" "it52" "it53" "it54" "it55" "it56" "it57" "it58" "it59" "it60"
#> [61] "it61" "it62" "it63" "it64" "it65" "it66" "it67" "it68" "it69" "it70"
#> [71] "it71" "it72" "it73" "it74" "it75" "it76" "it77" "it78" "it79" "it80"
```
