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


  # Do checks
  check_out <- do_checks_eatATA(
    nItems = nItems,
    itemIDs = itemIDs,
    itemValues = NULL,
    operator = operator,
    nForms = nForms,
    targetValue = targetValue,
    info_text = NULL,
    whichItems = NULL,
    itemValuesName = "itemsPerForm")

  nItems <- check_out$nItems
  itemIDs <- check_out$itemIDs
  itemValues <- check_out$itemValues
  operator <- check_out$operator
  info_text <- check_out$info_text


  # the targetValue should be smaller than or equal to the sum of the itemValues
  if(targetValue > nItems) stop("'targetValue' should be smaller than or equal to 'nItems'.")


  makeFormConstraint(nForms, itemValues, realVar = NULL,
                     operator, targetValue,
                     whichForms, sense = NULL,
                     info_text = info_text,
                     itemIDs = itemIDs)

}
