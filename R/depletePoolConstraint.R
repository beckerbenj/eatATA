#' Use complete item pool.
#'
#' Creates constraints that assure that every item in the item pool is used
#' (at least) once. Essentially a wrapper around \code{itemUsageConstraint}.
#'
#'@param nForms Number of forms to be created.
#'@param nItems Number of items in the item pool.
#'
#'@return A sparse matrix.
#'
#'@examples
#' depletePoolConstraint(2, 10)
#'
#'@export
depletePoolConstraint <- function(nForms, nItems){
  itemUsageConstraint(nForms, nItems, operator = ">=", targetValue = 1)
}
