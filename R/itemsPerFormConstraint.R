####
#############################################################################
#' Create number of items per test form constraints.
#'
#' Creates constraints related to the number of items in each test form.
#'
#' The number of items per test form is constrained to be either
#' (a) smaller or equal than (\code{operator = "<="}), (b) equal to
#' (\code{operator = "="}), or (c) greater or equal than
#' (\code{operator = ">="}) the chosen \code{value}.
#'
#'@inheritParams itemValuesConstraint
#'@inheritParams itemUsageConstraint
#'@param targetValue The target value to be used in the constraints. That is,
#'  the number of items per form.
#'
#'@return An object of class \code{"constraint"}.
#'
#'
#'@examples
#' ## Constrain the test forms to have exactly five items
#' itemsPerFormConstraint(3, operator = "=", targetValue = 5,
#'                        itemIDs = 1:20)
#'
#'@export
itemsPerFormConstraint <- function(nForms, nItems = NULL, operator = c("<=", "=", ">="),
                                   targetValue, whichForms = seq_len(nForms),
                                   itemIDs = NULL){

  operator <- match.arg(operator)
  suppressWarnings(nItems <- comb_itemIDs_nItems(itemIDs, nItems))

  # value cannot be greater than nForms
  if(targetValue > nItems) stop("'targetValue' should be smaller than or equal to 'nItems'.")


  itemValuesConstraint(nForms, itemValues = rep(1, nItems), operator,
                       targetValue, whichForms = whichForms,
                       info_text = paste0("itemsPerForm", operator, targetValue),
                       itemIDs)

}
