#' Constrain the sum of item values per form.
#'
#' Create constraints related to an item parameter/value. That is, the created
#' constraints assure that the sum of the item values (\code{itemValues}) per test form is either
#' (a) smaller than or equal to (\code{operator = "<="}), (b) equal to
#' (\code{operator = "="}), or (c) greater than or equal to (\code{operator = ">="})
#' the chosen \code{targetValue}.
#'
#'@param nForms Number of forms to be created.
#'@param itemValues Item parameter/values for which the sum per test form should be constrained.
#'@param operator A character indicating which operator should be used in the
#'  constraints, with three possible values: \code{"<="}, \code{"="},
#'  or \code{">="}. See details for more information.
#'@param targetValue the target test form value.
#'@param whichForms An integer vector indicating which test forms should be constrained. Defaults to all the test forms.
#'@param info_text a character string of length 1, to be used in the \code{"info"}-attribute of the resulting \code{constraint}-object.
#'@param itemIDs a character vector of item IDs in correct ordering, or NULL.
#'
#'@return An object of class \code{"constraint"}.
#'
#'@examples
#' ## constraints to make sure that the sum of the item values (1:10) is between
#' ## 4 and 6
#' combineConstraints(
#'   itemValuesConstraint(2, 1:10, operator = ">=", targetValue = 4),
#'   itemValuesConstraint(2, 1:10, operator = "<=", targetValue = 6)
#' )

#'
#'@export
itemValuesConstraint <- function(nForms, itemValues,
                                 operator = c("<=", "=", ">="),
                                 targetValue, whichForms = seq_len(nForms),
                                 info_text = NULL,
                                 itemIDs = names(itemValues)){

  operator <- match.arg(operator)

  # all arguments should be of lenght 1
  check <- sapply(list(nForms, operator, targetValue), length) == 1
  if(any(!check)) stop("The following arguments should have length 1: 'nForms', 'operator', 'targetValue'.")

  # itemValues should have length equal to itemIDs
  if(!is.null(itemIDs) && length(itemValues) != length(itemIDs)) stop("The length of 'itemValues' should be equal to 'itemIDs'.")

  # the targetValue should be smaller than or equal to the sum of the itemValues
  if(targetValue > sum(itemValues)) stop("The 'targetValue' should be smaller than the sum of the 'itemValues'.")

  # choose info_text for info
  if(is.null(info_text)) info_text <- paste0(deparse(substitute(itemValues)), operator, targetValue)

  if(length(info_text) > 1) stop("'info_text' should be a character string of length 1.")

  check_itemIDs(itemIDs)

  makeFormConstraint(nForms, itemValues, realVar = NULL,
                     operator, targetValue,
                     whichForms, sense = NULL,
                     info_text = info_text,
                     itemIDs = itemIDs)
}
