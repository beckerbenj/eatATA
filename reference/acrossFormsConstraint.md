# Constrain the sum of item values across multiple forms.

Create constraints related to item values. That is, the created
constraints assure that the sum of the item values (`itemValues`) across
test forms is either (a) smaller than or equal to (`operator = "<="`),
(b) equal to (`operator = "="`), or (c) greater than or equal to
(`operator = ">="`) the chosen `targetValue`. Note that the length of
`itemValues` should equal to the number of the length of `whichForms`
times `whichItems`.

## Usage

``` r
acrossFormsConstraint(
  nForms,
  nItems = NULL,
  operator = c("<=", "=", ">="),
  targetValue,
  whichForms = seq_len(nForms),
  whichItems = NULL,
  itemIDs = NULL,
  itemValues = NULL,
  info_text = NULL
)
```

## Arguments

- nForms:

  Number of forms to be created.

- nItems:

  Number of items in the item pool \[optional to create `itemIDs`
  automatically\].

- operator:

  A character indicating which operator should be used in the
  constraints, with three possible values: `"<="`, `"="`, or `">="`. See
  details for more information.

- targetValue:

  the target value. The target sum of item values across test forms.

- whichForms:

  An integer vector indicating across which test forms the sum should
  constrained. Defaults to all the test forms.

- whichItems:

  A vector indicating which items should be constrained. Defaults to all
  the items.

- itemIDs:

  a character vector of item IDs in correct ordering, or NULL.

- itemValues:

  a vector of item values for which the sum across test forms should be
  constrained. The item values will be repeated for each form. Defaults
  to a vector with ones for all items in the pool.

- info_text:

  a character string of length 1, to be used in the `"info"`-attribute
  of the resulting `constraint`-object.

## Value

An object of class `"constraint"`.

## Examples

``` r
## constraints to make sure that accross test form 1 and 3, only 4 items
##  of items 1:10 appear. Note that the constraint should be used in
##  in combination with constraining item overlap between the forms.
constr1 <- combineConstraints(
  acrossFormsConstraint(nForms = 3,
                        operator = "=", targetValue = 4,
                        whichForms = c(1, 3),
                        itemValues = c(rep(1, 10), rep(0, 10)),
                        itemIDs = 1:20),
  itemUsageConstraint(nForms = 3, nItems = 20, operator = "=", targetValue = 1,
                      itemIDs = 1:20)
                    )

## or alternatively
constr2 <- combineConstraints(
  acrossFormsConstraint(nForms = 3, nItems = 20,
                        operator = "=", targetValue = 4,
                        whichForms = c(1, 3),
                        whichItems = 1:10,
                        itemIDs = 1:20),
  itemUsageConstraint(nForms = 3, nItems = 20, operator = "=", targetValue = 1,
                      itemIDs = 1:20)
                    )
```
