# Constrain the sum of item values per form.

Create constraints related to an item parameter/value. That is, the
created constraints assure that the sum of the item values
(`itemValues`) per test form is either (a) smaller than or equal to
(`operator = "<="`), (b) equal to (`operator = "="`), or (c) greater
than or equal to (`operator = ">="`) the chosen `targetValue`.

## Usage

``` r
itemValuesConstraint(
  nForms,
  itemValues,
  operator = c("<=", "=", ">="),
  targetValue,
  whichForms = seq_len(nForms),
  info_text = NULL,
  itemIDs = names(itemValues)
)
```

## Arguments

- nForms:

  Number of forms to be created.

- itemValues:

  Item parameter/values for which the sum per test form should be
  constrained.

- operator:

  A character indicating which operator should be used in the
  constraints, with three possible values: `"<="`, `"="`, or `">="`. See
  details for more information.

- targetValue:

  the target test form value.

- whichForms:

  An integer vector indicating which test forms should be constrained.
  Defaults to all the test forms.

- info_text:

  a character string of length 1, to be used in the `"info"`-attribute
  of the resulting `constraint`-object.

- itemIDs:

  a character vector of item IDs in correct ordering, or NULL.

## Value

An object of class `"constraint"`.

## Details

When `operator` is `"<="`, the constraint can be mathematically
formulated as: \\\sum\_{i=1}^{I} v_i \times x\_{if} \leq t , \\ \\ \\
\code{for} \\ f \in G,\\ where \\I\\ refers to the number of items in
the item pool, \\v_i\\ is the `itemValue` for item \\i\\ and \\t\\ is
the `targetValue`. Further, \\G\\ corresponds to `whichForms`, so that
the above inequality constraint is repeated for every test form \\f\\ in
\\G\\. In addition, let \\\boldsymbol{x}\\ be a vector of binary
decision variables with length \\I \times F\\, where \\F\\ is `nForms`.
The binary decision variables \\x\_{if}\\ are defined as:

|                      |                              |                                              |
|----------------------|------------------------------|----------------------------------------------|
| \\\\\\\\\\\\\\\\\\\\ | \\x\_{if} = 1\\,\\\\\\\\\\\\ | if item \\i\\ is assigned to form \\f\\, and |
| \\\\\\\\\\\\\\\\\\\\ | \\x\_{if} = 0\\,\\\\\\\\\\\\ | otherwise.                                   |

## Examples

``` r
## constraints to make sure that the sum of the item values (1:10) is between
## 4 and 6
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
