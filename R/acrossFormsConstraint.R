#' Constrain the sum of item values across multiple forms.
#'
#' Create constraints related to item values. That is, the created
#' constraints assure that the sum of the item values (\code{itemValues}) across test forms is either
#' (a) smaller than or equal to (\code{operator = "<="}), (b) equal to
#' (\code{operator = "="}), or (c) greater than or equal to (\code{operator = ">="})
#' the chosen \code{targetValue}. Note that the length of \code{itemValues} should
#' equal to the number of the length of \code{whichForms} times \code{whichItems}.
#'
#'@inheritParams itemValuesConstraint
#'@inheritParams itemUsageConstraint
#'@param operator A character indicating which operator should be used in the
#'  constraints, with three possible values: \code{"<="}, \code{"="},
#'  or \code{">="}. See details for more information.
#'@param targetValue the target value. The target sum of item values across
#'  test forms.
#'@param whichForms An integer vector indicating across which test forms the
#'  sum should constrained. Defaults to all the test forms.
#'@param itemValues a vector of item values for which the sum across test forms should be constrained. The item values will be repeated for each form. Defaults to a vector with ones for all items in the pool.
#'@return An object of class \code{"constraint"}.
#'
#'@examples
#' ## constraints to make sure that accross test form 1 and 3, only 4 items
#' ##  of items 1:10 appear. Note that the constraint should be used in
#' ##  in combination with constraining item overlap between the forms.
#' combineConstraints(
#'   acrossFormsConstraint(nForms = 3,
#'                         operator = "=", targetValue = 4,
#'                         whichForms = c(1, 3),
#'                         itemValues = c(rep(1, 10), rep(0, 10)),
#'                         itemIDs = 1:20),
#'   itemUsageConstraint(nForms = 3, nItems = 20, operator = "=", targetValue = 1,
#'                       itemIDs = 1:20)
#'                     )
#'
#' ## or alternatively
#' combineConstraints(
#'   acrossFormsConstraint(nForms = 3, nItems = 20,
#'                         operator = "=", targetValue = 4,
#'                         whichForms = c(1, 3),
#'                         whichItems = 1:10,
#'                         itemIDs = 1:20),
#'   itemUsageConstraint(nForms = 3, nItems = 20, operator = "=", targetValue = 1,
#'                       itemIDs = 1:20)
#'                     )
#'
#'@export
acrossFormsConstraint <- function(nForms,
                                  nItems = NULL,
                                  operator = c("<=", "=", ">="),
                                  targetValue,
                                  whichForms = seq_len(nForms),
                                  whichItems = NULL,
                                  itemIDs = NULL,
                                  itemValues = NULL,
                                  info_text = NULL){

  # Do checks
  check_out <- do_checks_eatATA(
    nItems = nItems,
    itemIDs = itemIDs,
    itemValues = itemValues,
    operator = operator,
    nForms = nForms,
    targetValue = targetValue,
    info_text = info_text,
    whichItems = whichItems,
    itemValuesName = deparse(substitute(itemValues)))

  nItems <- check_out$nItems
  itemIDs <- check_out$itemIDs
  itemValues <- check_out$itemValues
  operator <- check_out$operator
  info_text <- check_out$info_text
  whichItems <- check_out$whichItems

  makeItemFormConstraint(nForms = nForms, nItems = nItems,
                         values = rep(itemValues, times = nForms),
                         realVar = NULL, operator = operator,
                         targetValue = targetValue,
                         whichForms = whichForms,
                         whichItems = whichItems,
                         sense = NULL,
                         info_text = info_text, itemIDs = itemIDs)
}
