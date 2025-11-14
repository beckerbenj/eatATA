# Typical Use of \`eatATA\`: a Pilot Study Example

`eatATA` efficiently translates test design requirements for Automated
Test Assembly (`ATA`) into constraints for a Mixed Integer Linear
Programming Model (MILP). A number of efficient and user-friendly
functions are available that translate conceptual test assembly
constraints to constraint objects for MILP solvers, like the `GLPK`
solver. In the remainder of this vignette I will illustrate the typical
use of `eatATA` using a case-based example. A general overview over
`eatATA` can be found in the vignette [Overview of `eatATA`
Functionality](https://beckerbenj.github.io/eatATA/articles/overview.md).

## Setup

The `eatATA` package can be installed from `CRAN`.

``` r
install.packages("eatATA")
```

First, `eatATA` is loaded into the `R` session.

``` r
# loading eatATA
library(eatATA)
```

## Item pool

No `ATA` without an item pool. In this example we use a fictional
example item pool of 80 items. The item pool information is stored as an
`excel` file that is included in the package. To import the item pool
information into `R` we recommend using the package `readxl`. This
package imports the data as a `tibble`, but in the code below, the item
pool is immediately transformed into a `data.frame`.

Note that `R` requires a rectangular data set. Yet, often excel files
store additional information in rows above or below the “rectangular”
item pool information. The `skip` argument in the `read_excel()`
function can be used to skip unnecessary rows in the `excel` file. (Note
that the item pool can also be directly accessed in the package via
`items`; see `?items` for more information.)

``` r
items_path <- system.file("extdata", "items.xlsx", package = "eatATA")

items <- as.data.frame(readxl::read_excel(path = items_path), stringsAsFactors = FALSE)
```

Inspection of the item pool indicates that the items have different
properties: item format (`MC`, `CMC`, `short_answer`, or `open`),
difficulty (`diff_1` - `diff_5`), average response times in minutes
(`time`). In addition, similar items can not be in the same booklet or
test form. This information is stored in the column `exclusions`, which
indicates which items are too similar and should not be in the same
booklet with the item in that row..

``` r
head(items)
#>      item                exclusions time subitems MC CMC short_answer open
#> 1 item_00          item_01, item_06  1.0        1 NA  NA            1   NA
#> 2 item_01          item_00, item_06  1.5        1 NA  NA            1   NA
#> 3 item_02 item_04, item_63, item_62  2.0        1 NA  NA           NA    1
#> 4 item_03                      <NA>  1.5        1 NA  NA            1   NA
#> 5 item_04 item_02, item_63, item_62  1.5        1 NA  NA            1   NA
#> 6 item_05                      <NA>  1.0        1 NA  NA            1   NA
#>   diff_1 diff_2 diff_3 diff_4 diff_5
#> 1      1     NA     NA     NA     NA
#> 2     NA      1     NA     NA     NA
#> 3     NA     NA      1     NA     NA
#> 4     NA     NA      1     NA     NA
#> 5     NA      1     NA     NA     NA
#> 6      1     NA     NA     NA     NA
```

## Prepare item information

Before defining the constraints, item pool data has to be in the correct
format. For instance, some dummy variables (indicator variables) in the
item pool use both `NA` and `0` to indicate “the category does not
apply”. Therefore, the dummy variables should be transformed so that
there are only two values (1 = “the category applies”, and 0 = “the
category does not apply”).

Often a set of dummy variables can be summarized into a single factor
variable. This is automatically done by the function
[`dummiesToFactor()`](https://beckerbenj.github.io/eatATA/reference/dummiesToFactor.md).
However, the function can only be used when the categories are mutually
exclusive. For instance, in the example item pool, items can contain
sub-items with different format or difficulties. As a result, some items
contain two sub-items with different formats. Therefore, in this
example, the
[`dummiesToFactor()`](https://beckerbenj.github.io/eatATA/reference/dummiesToFactor.md)
function throws an error and cannot be used.

``` r
# clean data set (categorical dummy variables must contain only 0 and 1)
items <- dummiesToFactor(items, dummies = c("MC", "CMC", "short_answer", "open"), facVar = "itemFormat")
#> Error in dummiesToFactor(items, dummies = c("MC", "CMC", "short_answer", : All values in the 'dummies' columns have to be 0, 1 or NA.
items <- dummiesToFactor(items, dummies = paste0("diff_", 1:5), facVar = "itemDiff")
#> Error in dummiesToFactor(items, dummies = paste0("diff_", 1:5), facVar = "itemDiff"): All values in the 'dummies' columns have to be 0, 1 or NA.
items[c(24, 33, 37, 47, 48, 54, 76), ]
#>       item       exclusions time subitems MC CMC short_answer open diff_1
#> 24 item_23             <NA>  3.5        2  1   1           NA   NA     NA
#> 33 item_32          item_36  1.5        2 NA  NA            2   NA      1
#> 37 item_36 item_27, item_32  1.5        2 NA  NA            2   NA      1
#> 47 item_46 item_54, item_44  2.5        2 NA  NA            2   NA     NA
#> 48 item_47 item_45, item_37  2.0        2 NA  NA            2   NA     NA
#> 54 item_53 item_43, item_59  2.5        2 NA  NA            2   NA     NA
#> 76 item_75             <NA>  1.5        2 NA  NA            2   NA     NA
#>    diff_2 diff_3 diff_4 diff_5
#> 24     NA      2     NA     NA
#> 33     NA      1     NA     NA
#> 37      1     NA     NA     NA
#> 47      1      1     NA     NA
#> 48     NA      1      1     NA
#> 54      1      1     NA     NA
#> 76     NA      1      1     NA
```

In addition, the column `short_answer` can have NA as a value, and is
consequently not a dummy variable. Therefore, we will (a) treat
`short_answer` as a numerical value, (b) collapse `MC` and `open` into a
new factor `MC_open_none`, (these dummies are mutually exclusive), and
(c) turn `CMC` and the difficulty indicators into factors. (See
`?autoItemValuesMinMax` and
[`?computeTargetValues`](https://beckerbenj.github.io/eatATA/reference/computeTargetValues.md)
for further information on the different treatment of factors and
numerical variables.)

``` r
# make new factor with three levels: "MC", "open" and "else"
items <- dummiesToFactor(items, dummies = c("MC", "open"), facVar = "MC_open_none")
#> Warning in dummiesToFactor(items, dummies = c("MC", "open"), facVar = "MC_open_none"): For these rows, there is no dummy variable equal to 1: 1, 2, 4, 5, 6, 7, 8, 9, 11, 12, 13, 14, 15, 17, 20, 21, 25, 28, 29, 30, 32, 33, 34, 36, 37, 38, 39, 40, 41, 44, 45, 46, 47, 48, 50, 54, 55, 58, 60, 65, 67, 68, 69, 70, 72, 74, 76, 77, 79, 80
#> A '_none_ 'category is created for these rows.
# clean data set (NA should be 0)
for(ty in c(paste0("diff_", 1:5), "CMC", "short_answer")){
  items[, ty] <- ifelse(is.na(items[, ty]), yes = 0, no = items[, ty])
}
# make factors of CMC dummi
items$f_CMC <- factor(items$CMC, labels = paste("CMC", c("no", "yes"), sep = "_"))

# example item format
table(items$short_answer)
#> 
#>  0  1  2 
#> 34 38  8
```

## `ATA` goal

In this example, the goal is to assemble 14 booklets out of the 80 items
item pool. All items should be assigned to one (and only one booklet),
so that there is no item overlap and the item pool is completely
depleted.

To be more precise, the required constraints are:

- no item overlap between test blocks

- complete item pool depletion

- equal distribution of item formats across test blocks

- equal difficulty distribution across test blocks

- some items can not be together in the same booklet (item exclusions)

- as similar as possible response times across booklets

Note that the booklets will later be manually assembled to test forms.

For ease of use, we set up two variables that we will use frequently:
the number of test forms or booklets to be created (`nForms`) and the
number of items in the item pool (`nItems`).

``` r
# set up fixed variables
nItems <- nrow(items)  # number of items
nForms <- 14           # number of blocks
```

`eatATA` offers a variety of functions that automatically compute the
constraints mentioned above and which are illustrated in the following.

## Objective Function

First, we are setting up an optimization constraint. This constraint is
not a clear *yes* or *no* constraint, and it does not have to be
attained perfectly. Instead, the solver will minimize the distance of
the actual booklet value for all booklets towards a target value. In our
example, we specify 10 minutes as the target response time `time` for
all booklets.

``` r
# optimize average time
av_time <- minimaxObjective(nForms, itemValues = items$time, targetValue = 10,
                             itemIDs = items$item)
```

## Set up constraints

The first two constraints (no item overlap and item pool depletion) can
be implemented by a single function:
[`itemUsageConstraint()`](https://beckerbenj.github.io/eatATA/reference/itemUsageConstraint.md).
To achieve this, the `operator` argument should be set to `"="`, meaning
that every item should be used exactly once in the booklet assembly.

``` r
itemOverlap <- itemUsageConstraint(nForms, targetValue = 1, 
                                   operator = "=", itemIDs = items$item) 
```

Constraints with respect to categorical variables or factors (like
`MC_open_none`) or numerical variables (like `short_answer`), can be
easily implemented using the `autoItemValuesMinMax()` function. The
result of this function depends on whether a factor or a numerical
variable is used. That is, `autoItemValuesMinMax()` automatically
determines the minimum and maximum frequency of each category of a
factor. But for numerical variables, it automatically determines the
target value.

The `allowedDeviation` argument specifies the allowed range between
booklets regarding the category or the numerical value. If the argument
is omitted, it defaults to “no deviation is allowed” for numerical
values, and to the minimal possible deviation for categorical variables
or factors. Hence, for numeric values, we specify
`allowedDeviation = 1`. The function prints the calculated target value
or the resulting allowed value range on booklet level.

``` r
# item formats
mc_openItems <- autoItemValuesMinMaxConstraint(nForms = nForms, itemValues = items$MC_open_none, 
                                     itemIDs = items$item)
#> The minimum and maximum frequences per test form for each item category are
#>        min max
#> _none_   3   4
#> MC       1   2
#> open     0   1
cmcItems <- autoItemValuesMinMaxConstraint(nForms = nForms, itemValues = items$f_CMC, itemIDs = items$item)
#> The minimum and maximum frequences per test form for each item category are
#>         min max
#> CMC_no    5   6
#> CMC_yes   0   1
saItems <- autoItemValuesMinMaxConstraint(nForms = nForms, itemValues = items$short_answer, 
                                allowedDeviation = 1, itemIDs = items$item)
#> The minimum and maximum values per test form are: min = 2.86 - max = 4.86

# difficulty categories
Items1 <- autoItemValuesMinMaxConstraint(nForms = nForms, itemValues = items$diff_1, 
                               allowedDeviation = 1, itemIDs = items$item)
#> The minimum and maximum values per test form are: min = 0 - max = 2
Items2 <- autoItemValuesMinMaxConstraint(nForms = nForms, itemValues = items$diff_2, 
                               allowedDeviation = 1, itemIDs = items$item)
#> The minimum and maximum values per test form are: min = 0.57 - max = 2.57
Items3 <- autoItemValuesMinMaxConstraint(nForms = nForms, itemValues = items$diff_3, 
                               allowedDeviation = 1, itemIDs = items$item)
#> The minimum and maximum values per test form are: min = 1.64 - max = 3.64
Items4 <- autoItemValuesMinMaxConstraint(nForms = nForms, itemValues = items$diff_4, 
                               allowedDeviation = 1, itemIDs = items$item)
#> The minimum and maximum values per test form are: min = 0 - max = 1.86
Items5 <- autoItemValuesMinMaxConstraint(nForms = nForms, itemValues = items$diff_5, 
                               allowedDeviation = 1, itemIDs = items$item)
#> The minimum and maximum values per test form are: min = 0 - max = 1.29
```

To implement item exclusion constraints, two function can be used:
[`itemTuples()`](https://beckerbenj.github.io/eatATA/reference/itemTuples.md)
and
[`itemExclusionConstraint()`](https://beckerbenj.github.io/eatATA/reference/itemExclusionConstraint.md).
When item exclusions are supplied as a single character string for each
item, with item identifiers separated by `", "`, they should be
transformed first.

``` r
# item exclusions variable
items$exclusions[1:5]
#> [1] "item_01, item_06"          "item_00, item_06"         
#> [3] "item_04, item_63, item_62" NA                         
#> [5] "item_02, item_63, item_62"
```

This transformation can be done using the `itemExclusionTuples()`
function, which creates so called *tuples*: pairs of exclusive items.
These *tuples* can be used directly with the
[`itemExclusionConstraint()`](https://beckerbenj.github.io/eatATA/reference/itemExclusionConstraint.md)
function.

``` r
# item exclusions
exclusionTuples <- itemTuples(items, idCol = "item", 
                                       infoCol = "exclusions", sepPattern = ", ")
excl_constraints <- itemExclusionConstraint(nForms = 14, itemTuples = exclusionTuples, 
                                            itemIDs = items$item)
```

Another helpful function is the
[`itemsPerFormConstraint()`](https://beckerbenj.github.io/eatATA/reference/itemsPerFormConstraint.md)
function, which constrains the number of items per booklet. However,
since this is not required in this example, we will not use these
constraints in the final `ATA` constraints.

``` r
# number of items per test form
min_Nitems <- floor(nItems / nForms) - 3
noItems <- itemsPerFormConstraint(nForms = nForms, operator = ">=", 
                                  targetValue = min_Nitems, itemIDs = items$item)
```

## Run solver

Before calling the optimization algorithm the specified constraints are
collected in a `list`.

``` r
# Prepare constraints
constr_list <- list(itemOverlap, mc_openItems, cmcItems, saItems, 
                      Items1, Items2, Items3, Items4, Items5, 
                      excl_constraints,
                      av_time)
```

Now we can call the
[`useSolver()`](https://beckerbenj.github.io/eatATA/reference/useSolver.md)
function, which restructures the constraints internally and solves the
optimization problem. Using the `solver` argument we specify `GLPK` as
the solver (other alternatives are `lpSolve`, `Symphony` and `Gurobi`).
Using the `timeLimit` argument we set the time limit to 10. This means
we limit the solver to stop searching for an optimal solution after 10
seconds. Note that the computation times might depend on the solver you
have selected.

``` r
# Optimization
solver_raw <- useSolver(constr_list, nForms = nForms, nItems = nItems, 
                        itemIDs = items$item, solver = "GLPK", timeLimit = 10)
```

    #>  [1] "GLPK Simplex Optimizer, v4.47"                                           
    #>  [2] "1046 rows, 1121 columns, 12824 non-zeros"                                
    #>  [3] "      0: obj =  0.000000000e+000  infeas = 4.170e+002 (80)"              
    #>  [4] "*   411: obj =  5.879030940e-001  infeas = 7.963e-016 (0)"               
    #>  [5] "*   438: obj =  2.857142857e-001  infeas = 3.116e-029 (0)"               
    #>  [6] "OPTIMAL SOLUTION FOUND"                                                  
    #>  [7] "GLPK Integer Optimizer, v4.47"                                           
    #>  [8] "1046 rows, 1121 columns, 12824 non-zeros"                                
    #>  [9] "1120 integer variables, all of which are binary"                         
    #> [10] "Integer optimization begins..."                                          
    #> [11] "+   438: mip =     not found yet >=              -inf        (1; 0)"     
    #> [12] "+  5675: >>>>>  1.500000000e+000 >=  2.857142857e-001  81.0% (303; 3)"   
    #> [13] "+  9322: >>>>>  1.000000000e+000 >=  2.857142857e-001  71.4% (540; 17)"  
    #> [14] "+ 17425: mip =  1.000000000e+000 >=  2.857142857e-001  71.4% (799; 433)" 
    #> [15] "+ 26418: mip =  1.000000000e+000 >=  2.857142857e-001  71.4% (1341; 491)"
    #> [16] "+ 34686: mip =  1.000000000e+000 >=  2.857142857e-001  71.4% (1850; 551)"
    #> [17] "+ 45535: mip =  1.000000000e+000 >=  2.857142857e-001  71.4% (2356; 644)"
    #> [18] "+ 54325: mip =  1.000000000e+000 >=  2.857142857e-001  71.4% (2695; 737)"
    #> [19] "TIME LIMIT EXCEEDED; SEARCH TERMINATED"
    #> The solution is feasible, but may not be optimal

The function provides output that indicates whether an optimal solution
has been found. In our case, a viable solution has been found but the
function reached the time limit before finding the optimal solution.

If there is no feasible solution, one option is to relax some of the
constraints. Further, for first diagnostic purposes you can omit some
constraints completely, to see which constraints are especially
challenging. If you have a better grasp of the possibilities of the item
pool, you can add these constraints back, but for example with larger
`allowedDeviations`.

## Inspect Solution

The solution provided by `eatATA` can be inspected using the
[`inspectSolution()`](https://beckerbenj.github.io/eatATA/reference/inspectSolution.md)
function. It allows us to inspect the assembled item blocks at a first
glance, including some column sums.

``` r
out_list <- inspectSolution(solver_raw, items = items, idCol = "item", colSums = TRUE,
                            colNames = c("time", "subitems", 
                                         "MC", "CMC", "short_answer", "open",
                                         paste0("diff_", 1:5)))

# first two booklets
out_list[1:2]
#> $form_1
#>     time subitems MC CMC short_answer open diff_1 diff_2 diff_3 diff_4 diff_5
#> 17   2.0        1 NA   0            1   NA      0      0      0      0      1
#> 19   2.0        1  1   0            0   NA      0      0      0      1      0
#> 27   1.5        1  1   0            0   NA      0      0      1      0      0
#> 41   1.0        1 NA   0            1   NA      0      0      1      0      0
#> 44   1.5        1 NA   0            1   NA      0      1      0      0      0
#> 55   1.0        1 NA   0            1   NA      0      1      0      0      0
#> Sum  9.0        6 NA   0            4   NA      0      2      2      1      1
#> 
#> $form_2
#>     time subitems MC CMC short_answer open diff_1 diff_2 diff_3 diff_4 diff_5
#> 1    1.0        1 NA   0            1   NA      1      0      0      0      0
#> 10   1.0        1  1   0            0   NA      0      1      0      0      0
#> 20   1.5        1 NA   0            1   NA      0      0      1      0      0
#> 22   2.5        1  1   0            0   NA      0      0      1      0      0
#> 66   2.5        1 NA   0            0    1      0      1      0      0      0
#> 76   1.5        2 NA   0            2   NA      0      0      1      1      0
#> Sum 10.0        7 NA   0            4   NA      1      2      3      1      0
```

In our case we want to assemble the created booklets into test forms.
Therefore, we are interested in booklet exclusions that can result from
item exclusions. The
[`analyzeBlockExclusion()`](https://beckerbenj.github.io/eatATA/reference/analyzeBlockExclusion.md)
function can be used to obtain tuples with booklet exclusions.

``` r
analyzeBlockExclusion(solverOut = solver_raw, item = items, idCol = "item", 
                      exclusionTuples = exclusionTuples)
#>     Name 1  Name 2
#> 1  form_12  form_2
#> 2  form_11  form_2
#> 3  form_11 form_12
#> 4  form_13  form_5
#> 5  form_13  form_4
#> 6  form_13  form_6
#> 7   form_4  form_5
#> 8   form_5  form_6
#> 9  form_12  form_4
#> 10 form_10  form_7
#> 11 form_10 form_13
#> 12 form_10  form_2
#> 13  form_6  form_9
#> 14 form_13  form_3
#> 15 form_13  form_7
#> 16  form_2  form_7
#> 17 form_13  form_2
#> 18 form_11  form_8
#> 19  form_1 form_12
#> 20  form_1 form_14
#> 22 form_12  form_9
#> 23 form_10  form_6
#> 25  form_1 form_10
#> 26 form_13  form_8
#> 27 form_11  form_3
#> 28  form_3  form_4
#> 29  form_5  form_8
#> 32  form_5  form_7
#> 35  form_1  form_3
#> 37  form_1  form_9
#> 38 form_12  form_3
#> 39  form_1  form_6
#> 40 form_12 form_14
#> 41  form_3  form_8
#> 42 form_14  form_3
#> 44  form_4  form_6
#> 45 form_12  form_7
```

## Save as Excel

To save the item distribution on blocks or test forms, we can use the
[`appendSolution()`](https://beckerbenj.github.io/eatATA/reference/appendSolution.md)
function. The function simply merges the new variables containing the
solution to the test assembly problem to the original item pool.

``` r
out_df <- appendSolution(solver_raw, items = items, idCol = "item")
```

Finally, when the solution should be exported as an `excel` file
(`.xlsx`), this can, for example, be achieved via the `eatAnalysis`
package, which has to be installed from `Github`.

``` r
devtools::install_github("beckerbenj/eatAnalysis")

eatAnalysis::write_xlsx(out_df, filePath = "example_excel.xlsx",
                        row.names = FALSE)
```
