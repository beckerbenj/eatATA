

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
#'@param value The value to be used in the constraints
#'
#'@return A sparse matrix.
#'
#'
#'@examples
#' ## Constrain the test forms to have exactly five items
#' itemsPerFormConstraint(3, 20, operator = "=", value = 5)
#'
#'@export
itemsPerFormConstraint <- function(nForms, nItems, operator = c("<=", "=", ">="), value){

  operator <- match.arg(operator)

  # all arguments should be of lenght 1
  check <- sapply(list(nForms, nItems, operator, value), length) == 1
  if(any(!check)) stop("All arguments should have length 1.")

  # value cannot be greater than nForms
  if(value > nItems) stop("'value' should be smaller than or equal to 'nItems'.")

  # change operator to sign (numeric and character vectors cannot be combined in Matrix)
  sign <- switch(operator,
                 "<=" = -1,
                 "=" = 0,
                 ">=" = 1)

  # number of binary decision variables
  M <- nForms*nItems

  M <- nForms*nItems
  Matrix::sparseMatrix(
    i = c(rep(1:nForms, each = nItems), 1:nForms           , 1:nForms),
    j = c(1:(M)                       , rep(M+2, nForms)   , rep(M+3, nForms)),
    x = c(rep(1, M)                   , rep(sign, nForms)  , rep(value, nForms)))
}
