# Use a solver for a list of constraints.

Use a mathematical programming solver to solve a list for constrains.

## Usage

``` r
useSolver(
  allConstraints,
  solver = c("GLPK", "lpSolve", "Gurobi", "Symphony"),
  timeLimit = Inf,
  formNames = NULL,
  ...
)
```

## Arguments

- allConstraints:

  List of constraints.

- solver:

  A character string indicating the solver to use.

- timeLimit:

  The maximal runtime in seconds.

- formNames:

  A character vector with names to give to the forms.

- ...:

  Additional arguments for the solver.

## Value

A list with the following elements:

- `solution_found`:

  Was a solution found?

- `solution`:

  Numeric vector containing the found solution.

- `solution_status`:

  Was the solution optimal?

## Details

Wrapper around the functions of different solvers
(`gurobi::gurobi(), lpSolve::lp(), ...` for a list of constraints set up
via `eatATA`. `Rglpk` is used per default.

Additional arguments can be passed through `...` and vary from solver to
solver (see their respective help pages,
[`lp`](https://rdrr.io/pkg/lpSolve/man/lp.html) or
[`Rglpk_solve_LP`](https://rdrr.io/pkg/Rglpk/man/Rglpk_solve.html)); for
example time limits can not be set for `lpSolve`.

## Examples

``` r
nForms <- 2
nItems <- 4

# create constraits
target <- minimaxObjective(nForms = nForms, c(1, 0.5, 1.5, 2),
                       targetValue = 2, itemIDs = 1:nItems)
noItemOverlap <- itemUsageConstraint(nForms, operator = "=", itemIDs = 1:nItems)
testLength <- itemsPerFormConstraint(nForms = nForms,
                           operator = "<=", targetValue = 2, itemIDs = 1:nItems)

# use a solver
result <- useSolver(list(target, noItemOverlap, testLength),
  itemIDs = paste0("Item_", 1:4),
  solver = "GLPK")
#> GLPK Simplex Optimizer 5.0
#> 10 rows, 9 columns, 36 non-zeros
#>       0: obj =   0.000000000e+00 inf =   8.000e+00 (6)
#>       6: obj =   5.000000000e-01 inf =   0.000e+00 (0)
#> *     9: obj =   5.000000000e-01 inf =   0.000e+00 (0)
#> OPTIMAL LP SOLUTION FOUND
#> GLPK Integer Optimizer 5.0
#> 10 rows, 9 columns, 36 non-zeros
#> 8 integer variables, all of which are binary
#> Integer optimization begins...
#> Long-step dual simplex will be used
#> +     9: mip =     not found yet >=              -inf        (1; 0)
#> +     9: >>>>>   5.000000000e-01 >=   5.000000000e-01   0.0% (1; 0)
#> +     9: mip =   5.000000000e-01 >=     tree is empty   0.0% (0; 1)
#> INTEGER OPTIMAL SOLUTION FOUND
#> Optimal solution found.


```
