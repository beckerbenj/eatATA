#' Create single value constraints.
#'
#' Create constraints related to an item parameter/value. That is, the created
#' constraints assure that the sum of the item values (\code{itemValues}) per test form is either
#' (a) smaller than or equal to (\code{operator = "<="}), (b) equal to
#' (\code{operator = "="}), or (c) greater than or equal to (\code{operator = ">="})
#' the chosen \code{targetValue}.
#'
#'@param nForms Number of forms to be created.
#'@param nItems Number of items in the item pool.
#'@param itemValues Item parameter/values for which the sum per test form should be constrained.
#'@param operator A character indicating which operator should be used in the
#'  constraints, with three possible values: \code{"<="}, \code{"="},
#'  or \code{">="}. See details for more information.
#'@param targetValue the target test form value
#'
#'@return A sparse matrix.
#'
#'@examples
#' ## constraints to make sure that the sum of the item values (1:10) is between
#' ## 4 and 6
#' rbind(
#'   itemValuesConstraint(2, 10, 1:10, operator = ">=", targetValue = 4),
#'   itemValuesConstraint(2, 10, 1:10, operator = "<=", targetValue = 6))
#'
#'@export
itemValuesConstraint <- function(nForms, nItems, itemValues, operator = c("<=", "=", ">="), targetValue){


  operator <- match.arg(operator)

  # all arguments should be of lenght 1
  check <- sapply(list(nForms, nItems, operator, targetValue), length) == 1
  if(any(!check)) stop("The following arguments should have length 1: 'nForms', 'nItems', 'operator', 'targetValue'.")

  # itemValues should have length equal to nItems
  if(length(itemValues) != nItems) stop("The lenght of 'itemValues' should be equal to 'nItems'.")


  # the targetValue should be smaller than or equal to the sum of the itemValues
  if(targetValue > sum(itemValues)) stop("The 'targetValue' should be smaller than the sum of the 'itemValues'.")

  # change operator to sign (numeric and character vectors cannot be combined in Matrix)
  sign <- switch(operator,
                 "<=" = -1,
                 "=" = 0,
                 ">=" = 1)

  # number of binary decision variables
  M <- nForms*nItems

  Matrix::sparseMatrix(
    i = c(rep(1:nForms, each = nItems),     1:nForms,          1:nForms,                  1:nForms),
    j = c(1:M,                              rep(M+1, nForms),  rep(M+2, nForms),          rep(M+3, nForms)),
    x = c(rep(itemValues, times = nForms),  rep(0, nForms),    rep(sign, each = nForms),  rep(targetValue, nForms)))}
