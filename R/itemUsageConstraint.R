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
#' If certain items are required in the resulting test form(s), as for example anchor items,
#' \code{whichItems} can be used to constrain the usage of these items to be exactly 1.
#' \code{whichItems} can either be a numeric vector with item numbers or a character vector
#' with item identifiers corresponding to \code{itemIDs}.
#'
#'@inheritParams itemValuesConstraint
#'@param nItems Number of items in the item pool [optional to create \code{itemIDs} automatically].
#'@param formValues vector with values or weights for each form. Defaults to 1 for each form.
#'@param targetValue The value to be used in the constraints
#'@param whichItems A vector indicating which items should be constrained. Defaults to all the items.
#'
#'@return An object of class \code{"constraint"}.
#'
#'@examples
#' ## create no-item overlap constraints with item pool depletion
#' ##  for 2 test forms with an item pool of 20 items
#' itemUsageConstraint(2, operator = "=", targetValue = 1,
#'                     itemIDs = 1:20)
#'
#' ## force certain items to be in the test, others not
#' usage1 <- itemUsageConstraint(2, operator = "<=", targetValue = 1,
#'                     itemIDs = paste0("item", 1:20))
#' usage2 <- itemUsageConstraint(2, operator = "=", targetValue = 1,
#'                     itemIDs = paste0("item", 1:20),
#'                     whichItems = c("item5", "item8", "item10"))
#'
#'@export
# constraints sum of item values over forms
itemUsageConstraint <- function(nForms, nItems = NULL, formValues = rep(1, nForms),
                                operator = c("<=", "=", ">="),
                                targetValue = 1, whichItems = NULL,
                                info_text = NULL,
                                itemIDs = NULL){

  # Do checks
  check_out <- do_checks_eatATA(
    nItems = nItems,
    itemIDs = itemIDs,
    itemValues = NULL,
    formValues = formValues,
    operator = operator,
    nForms = nForms,
    targetValue = targetValue,
    info_text = info_text,
    whichItems = whichItems,
    testFormValues = TRUE,
    itemValuesName = deparse(substitute(formValues)))

  nItems <- check_out$nItems
  itemIDs <- check_out$itemIDs
  itemValues <- check_out$itemValues
  operator <- check_out$operator
  info_text <- check_out$info_text
  whichItems <- check_out$whichItems
  formValues <- check_out$formValues



  # the targetValue should be smaller than or equal to the sum of the formValues
  if(targetValue > sum(formValues)) stop("The 'targetValue' should be smaller than the sum of the 'formValues'.")

#
#  # choose info_text for info
#  if(is.null(info_text)) info_text <- paste0(deparse(substitute(formValues)), operator, targetValue)

  makeItemConstraint(nForms, nItems, formValues, realVar = NULL,
                     operator, targetValue,
                     whichItems, sense = NULL,
                     info_text = info_text,
                     itemIDs = itemIDs)
}


