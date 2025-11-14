# Calculate Cumulants Lognormal Response Time Distribution

These functions have been deprecated. See
[`getMean3PLN`](https://beckerbenj.github.io/eatATA/reference/getMean3PLN.md)
or
[`getVar3PLN`](https://beckerbenj.github.io/eatATA/reference/getMean3PLN.md)
instead.

## Usage

``` r
calculateExpectedRT(lambda, phi, zeta, sdEpsi)

calculateExpectedRTvar(lambda, phi, zeta, sdEpsi)
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

## Functions

- `calculateExpectedRT()`: Calculate mean 3PLN

- `calculateExpectedRTvar()`: Calculate mean 2PLN
