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
#'@inheritParams itemValuesConstraint
#'@param nItems Number of items in the item pool [optional to create \code{itemIDs} automatically].
#'@param formValues vector with values or weights for each form. Defaults to 1 for each form.
#'@param targetValue The value to be used in the constraints
#'@param whichItems A vector indicating which items should be constrained. Defaults to all the items forms.
#'
#'@return An object of class \code{"constraint"}.
#'
#'@examples
#' ## create no-item overlap constraints with item pool depletion
#' ##  for 2 test forms with an item pool of 20 items
#' itemUsageConstraint(2, operator = "=", targetValue = 1,
#'                     itemIDs = 1:20)
#'
#'@export
# constraints sum of item values over forms
itemUsageConstraint <- function(nForms, nItems = NULL, formValues = rep(1, nForms),
                                operator = c("<=", "=", ">="),
                                targetValue = 1, whichItems = seq_len(nItems),
                                info_text = NULL,
                                itemIDs = NULL){

  operator <- match.arg(operator)

  nItems <- comb_itemIDs_nItems(itemIDs, nItems = nItems)

  # all arguments should be of lenght 1
  check <- sapply(list(nForms, nItems, operator, targetValue), length) == 1
  if(any(!check)) stop("The following arguments should have length 1: 'nForms', 'nItems', 'operator', 'targetValue'.")

  # formValues should have length equal to nForms
  if(length(formValues) != nForms) stop("The length of 'formValues' should be equal to 'nForms'.")

  # the targetValue should be smaller than or equal to the sum of the formValues
  if(targetValue > sum(formValues)) stop("The 'targetValue' should be smaller than the sum of the 'formValues'.")


  # choose info_text for info
  if(is.null(info_text)) info_text <- paste0(deparse(substitute(formValues)), operator, targetValue)

  makeItemConstraint(nForms, nItems, formValues, realVar = NULL,
                     operator, targetValue,
                     whichItems, sense = NULL,
                     info_text = info_text,
                     itemIDs = itemIDs)
}
