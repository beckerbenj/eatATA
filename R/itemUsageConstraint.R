#' Create item usage constraints.
#'
#' Creates constraints related to item usage. That is, the number of times an item
#' is selected is constrained to be either (a) smaller or equal than
#' (\code{operator = "<="}), (b) equal to (\code{operator = "="}),
#' or (c) greater or equal than (\code{operator = ">="}) the chosen \code{value}.
#'
#' When \code{operator = "<="} and \code{value = 1} (the default), each item can
#' be selected maximally once, which corresponds with assuring that there is no
#' item overlap between the forms. When \code{operator = "="} and \code{value = 1},
#' each item is used exactly once, which corresponds to no item-overlap and
#' complete item pool depletion.
#'
#'@param nForms Number of forms to be created.
#'@param nItems Number of items in the item pool.
#'@param operator a character indicating which operator should be used in the
#'  constraints, with three possible values: \code{"<="}, \code{"="},
#'  or \code{">="}. See details for more information.
#'@param targetValue The value to be used in the constraints
#'
#'@return A sparse matrix.
#'
#'@examples
#' ## create no-item overlap constraints with item pool depletion
#' ##  for 2 test forms with an item pool of 20 items
#' itemUsageConstraint(2, 20, operator = "=", targetValue = 1)
#'
#'@export
itemUsageConstraint <- function(nForms, nItems, operator = c("<=", "=", ">="), targetValue = 1){

  operator <- match.arg(operator)

  # all arguments should be of length 1
  check <- sapply(list(nForms, nItems, operator, targetValue), length) == 1
  if(any(!check)) stop("All arguments should have length 1.")

  # value cannot be greater than nForms
  if(targetValue > nForms) stop("'value' should be smaller than or equal to 'nForms'.")

  # change operator to sign (numeric and character vectors cannot be combined in Matrix)
  sign <- switch(operator,
                 "<=" = -1,
                 "=" = 0,
                 ">=" = 1)

  # number of binary decision variables
  M <- nForms*nItems


  # return sparse matrix
  Matrix::sparseMatrix(
    # A matrix in constraints           operator-indicator    d vector
    i = c(rep(1:nItems, times = nForms), 1:nItems           , 1:nItems),
    j = c(1:(M)                        , rep(M+2, nItems)   , rep(M+3, nItems)),
    x = c(rep(1, M)                    , rep(sign, nItems)  , rep(targetValue, nItems)))
}
