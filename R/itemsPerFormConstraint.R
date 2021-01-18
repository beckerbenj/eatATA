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
#'@param targetValue The target value to be used in the constraints. That is,
#'  the number of items per form.
#'
#'@return An object of class \code{"constraint"}.
#'
#'
#'@examples
#' ## Constrain the test forms to have exactly five items
#' itemsPerFormConstraint(3, 20, operator = "=", targetValue = 5)
#'
#'@export
itemsPerFormConstraint <- function(nForms, nItems, operator = c("<=", "=", ">="),
                                   targetValue, whichForms = seq_len(nForms),
                                   itemIDs = NULL){

  operator <- match.arg(operator)

  # value cannot be greater than nForms
  if(targetValue > nItems) stop("'targetValue' should be smaller than or equal to 'nItems'.")

  itemValuesConstraint(nForms, nItems, itemValues = rep(1, nItems), operator,
                       targetValue, whichForms = whichForms,
                       info_text = paste0("itemsPerForm", operator, targetValue),
                       itemIDs)

}
