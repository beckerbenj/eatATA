# Convert dummy variables to factor.

Convert multiple dummy variables into a single factor variable.

## Usage

``` r
dummiesToFactor(dat, dummies, facVar, nameEmptyCategory = "_none_")
```

## Arguments

- dat:

  A `data.frame`.

- dummies:

  Character vector containing the names of the dummy variables in the
  `data.frame`.

- facVar:

  Name of the factor variable, that should be created.

- nameEmptyCategory:

  a character of length 1 that defines the name of cases for which no
  dummy is equal to one.

## Value

A `data.frame` containing the newly created factor.

## Details

The content of a single factor variable can alternatively be stored in
multiple dichotomous dummy variables coded with `0`/`1` or `NA`/`1`. `1`
always has to refer to "this category applies". The function requires
factor levels to be exclusive (i.e. only one factor level applies per
row.).

## Examples

``` r
# Example data set
tdat <- data.frame(ID = 1:3, d1=c(1, 0, 0), d2 = c(0, 1, 0), d3 = c(0, 0, 1))

dummiesToFactor(tdat, dummies = c("d1", "d2", "d3"), facVar = "newFac")
#>   ID d1 d2 d3 newFac
#> 1  1  1  0  0     d1
#> 2  2  0  1  0     d2
#> 3  3  0  0  1     d3
```
