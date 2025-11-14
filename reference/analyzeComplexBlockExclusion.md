# Analyze complex block exclusiveness

Use exclusion tuples information from independent test assembly problems
to determine which assembled test blocks are exclusive.

## Usage

``` r
analyzeComplexBlockExclusion(
  solverOut_list,
  items_list,
  idCol,
  exclusionTuples_list
)
```

## Arguments

- solverOut_list:

  List of objects created by `useSolver`.

- items_list:

  List of original `data.frame` containing information on item level.

- idCol:

  Column name in `items` containing item IDs. These will be used for
  matching to the solver output.

- exclusionTuples_list:

  List of `data.frames` with two columns, containing tuples with item
  IDs which should be in test forms exclusively. Must be the same
  objects as used in
  [`itemExclusionConstraint`](https://beckerbenj.github.io/eatATA/reference/itemExclusionConstraint.md).

## Value

A `data.frame` of block exclusions.

## Details

If exclusion tuples have been used to assemble test forms (using the
[`itemExclusionConstraint`](https://beckerbenj.github.io/eatATA/reference/itemExclusionConstraint.md)
function), the resulting item blocks might also be exclusive. Using the
initially used item exclusion tuples and the optimal solution given by
`useSolver` this function determines, which item blocks are exclusive
and can not be together in an assembled test form.
`analyzeComplexBlockExclusion` allows analyzing block exclusiveness from
separate test assembly problems. This can be useful if test forms
consist of blocks containing different domains or dimensions.

## Examples

``` r
## Full workflow using itemExclusionTuples
# tbd

```
