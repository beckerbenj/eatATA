#' Use complete item pool.
#'
#' Creates constraints that assure that every item in the item pool is used
#' (at least) once. Essentially a wrapper around \code{itemUsageConstraint}.
#'
#'@inheritParams itemValuesConstraint
#'@inheritParams itemUsageConstraint
#'
#'@return A sparse matrix.
#'
#'@examples
#' depletePoolConstraint(2, itemIDs = 1:10)
#'
#'@export
depletePoolConstraint <- function(nForms, nItems = NULL, itemIDs = NULL){
  itemUsageConstraint(nForms, nItems, operator = ">=", targetValue = 1, itemIDs = itemIDs)
}
