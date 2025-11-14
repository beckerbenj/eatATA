# Calculate Item Information Function

Calculate item information function given item parameters of the 1PL,
2PL or 3PL IRT model.

## Usage

``` r
calculateIIF(A = rep(1, length(B)), B, C = rep(0, length(B)), theta, D = 1.7)
```

## Arguments

- A:

  Vector of discrimination parameters.

- B:

  Vector of difficulty parameters.

- C:

  Vector of pseudo-guessing parameters.

- theta:

  Vector of time intensity parameters.

- D:

  the constant that should be used. Defaults to 1.7.

## Value

a matrix, with columns for different `theta` and rows for different
items

## References

van der Linden, W. J. (2005). *Linear models for optimal test design*.
New York, NY: Springer.

## Examples

``` r
# TIF for a single item (2PL model)
calculateIIF(A = 0.8, B = 1.1, theta = 0)
#>        theta=0
#> [1,] 0.2765624

# TIF for multiple items (1PL model)
calculateIIF(B = c(1.1, 0.8, 0.5), theta = 0)
#>        theta=0
#> [1,] 0.3343971
#> [2,] 0.4697007
#> [3,] 0.6062435

# TIF for multiple theta-values (3PL model)
calculateIIF(B = -0.5, C = 0.25, theta = c(-1, 0, 1))
#>      theta=-1   theta=0   theta=1
#> [1,] 0.286882 0.4107883 0.1428265

# TIF for multiple items and multiple ability levels (2PL model)
calculateIIF(A = c(0.7, 1.1, 0.8), B = c(1.1, 0.8, 0.5),
            theta = c(-1, 0, 1))
#>        theta=-1   theta=0   theta=1
#> [1,] 0.09935811 0.2371010 0.3527746
#> [2,] 0.11281424 0.5228757 0.8443530
#> [3,] 0.18833807 0.4128116 0.4128116
```
