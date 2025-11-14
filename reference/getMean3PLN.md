# Calculate Cumulants Lognormal Response Time Distribution

Calculate the first and second cumulants (i.e., mean and variance) of
item response time distributions given item parameters of the
three-parameter log-normal model (3PLN) for response times.

## Usage

``` r
getMean3PLN(lambda, phi = rep(1, length(lambda)), zeta, sdEpsi)

getMean2PLN(lambda, zeta, sdEpsi)

getVar3PLN(lambda, phi = rep(1, length(lambda)), zeta, sdEpsi)

getVar2PLN(lambda, zeta, sdEpsi)
```

## Arguments

- lambda:

  Vector of time intensity parameters.

- phi:

  \[optional\] Vector of speed sensitivity parameters.

- zeta:

  Vector of person speed parameters.

- sdEpsi:

  Vector of item specific residual variances.

## Value

a matrix with either the mean or the variance of the response time
distributions, with columns for different `zeta` and rows for different
items

## Details

Calculate the first and second cumulant of the two-parameter log-normal
(2PLN) model for response times according to van der Linden (2006) or
the 3PLN according to Klein Entink et al. (2009). If the speed
sensitivity parameter `phi` in the 3PLN equals `1`, the model reduces to
the 2PLN, yet with a different parameterization for the item specific
residual variance `sdEpsi` compared to van der Linden (2006).

The cumulants are computed for one or more speed parameters, and for one
or more sets of item parameters.

The calculation is based on Fenton (1960). For the model by van der
Linden (2006), the calculation was first introduced by van der Linden
(2011).

## Functions

- `getMean3PLN()`: Calculate mean 3PLN

- `getMean2PLN()`: Calculate mean 2PLN

- `getVar3PLN()`: Calculate variance 3PLN

- `getVar2PLN()`: Calculate variance 2PLN

## References

Fenton, L. (1960). The sum of log-normal probability distributions in
scatter transmission systems. *IRE Transactions on Communication
Systems*, 8, 57-67.

Klein Entink, R. H., Fox, J.-P., & van der Linden, W. J. (2009). A
multivariate multilevel approach to the modeling of accuracy and speed
of test takers. *Psychometrika*, 74(1), 21-48.

van der Linden, W. J. (2006). A lognormal model for response times on
test items. *Journal of Educational and Behavioral Statistics, 31(2),
181-204*.

van der Linden, W. J. (2011). Test design and speededness. *Journal of
Educational Measurement*, 48(1), 44-60.

## Examples

``` r
# expected RT for a single item (van der Linden model)
getMean2PLN(lambda = 3.8, zeta = 0, sdEpsi = 0.3)
#>        zeta=0
#> [1,] 46.75868
getVar2PLN(lambda = 3.8, zeta = 0, sdEpsi = 0.3)
#>        zeta=0
#> [1,] 205.9003

# expected RT for multiple items (van der Linden model)
getMean2PLN(lambda = c(4.1, 3.8, 3.5), zeta = 0,
                   sdEpsi = c(0.3, 0.4, 0.2))
#>        zeta=0
#> [1,] 63.11762
#> [2,] 48.42422
#> [3,] 33.78443
getVar2PLN(lambda = c(4.1, 3.8, 3.5), zeta = 0,
                   sdEpsi = c(0.3, 0.4, 0.2))
#>         zeta=0
#> [1,] 375.17473
#> [2,] 406.86644
#> [3,]  46.58091

# expected RT for multiple items and multiple spped levels (Klein Entink model)
getMean3PLN(lambda = c(3.7, 4.1, 3.8), phi = c(1.1, 0.8, 0.5),
                    zeta = c(-1, 0, 1), sdEpsi = c(0.3, 0.4, 0.2))
#>        zeta=-1   zeta=0   zeta=1
#> [1,] 127.10328 42.30901 14.08345
#> [2,] 145.47438 65.36585 29.37077
#> [3,]  75.18863 45.60421 27.66035
getVar3PLN(lambda = c(3.7, 4.1, 3.8), phi = c(1.1, 0.8, 0.5),
                    zeta = c(-1, 0, 1), sdEpsi = c(0.3, 0.4, 0.2))
#>        zeta=-1    zeta=0    zeta=1
#> [1,] 1521.4086 168.57687  18.67885
#> [2,] 3671.9751 741.35899 149.67780
#> [3,]  230.7168  84.87596  31.22412
```
