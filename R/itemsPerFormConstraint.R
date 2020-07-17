

##----------------------------------------------------------------
## nrItInForm.R
##----------------------------------------------------------------

## noItemOverlap.R is used as a source file in the simulation studies for the manuscript
## entitled: "Multidimensional Linear Test Assembly Using Mixed Integer Linear
## Programming".
## This file creates a funcion that writes a sparse matrix that can be used in the
## writeMILP function (sourse-file writeMILP.R)
## The resulting sparse matrix is a combination of (1) the matrix A
## (dim = c(nrForms, nrItems * nrForms + 1)) with weights for all the MILP-
## variables (i.e, the left hand side of the constraints), (2) a vector (length nrForms)
## with the sign of the constraints represented by a number (-1 = leq, 0 = eq, 1 = geq),
## and (3) a vector d (length nrItems) with the right hand side of the constraints.

####
#############################################################################
#' Create number of items per test form constraints.
#'
#' Creates constraints related to the number of items in each test form.
#' That is, the number of items per test form is constrained to be either
#' (a) smaller or equal than (\code{operator = "<="}), (b) equal to
#' (\code{operator = "="}), or (c) greater or equal than
#' (\code{operator = ">="}) the chosen \code{value}.
#'
#'@param nForms Number of forms to be created.
#'@param nItems Number of items in the item pool.
#'@param operator a character indicating which operator should be used in the
#'  constraints, with three possible values: \code{"<="}, \code{"="},
#'  or \code{">="}. See details for more information.
#'@param value The target value to be used in the constraints. That is,
#'  the number of items per form.
#'
#'@return A sparse matrix.
#'
#'
#'@examples
#' ## Constrain the test forms to have exactly five items
#' itemsPerFormConstraint(3, 20, operator = "=", targetValue = 5)
#'
#'@export
itemsPerFormConstraint <- function(nForms, nItems, operator = c("<=", "=", ">="), targetValue){

  operator <- match.arg(operator)

  # value cannot be greater than nForms
  if(targetValue > nItems) stop("'targetValue' should be smaller than or equal to 'nItems'.")

  itemValuesConstraint(nForms, nItems, itemValues = rep(1, nItems), operator, targetValue)

}
