#' Create item category constraints.
#'
#' Create constraints related to item categories/groupings (as
#' represented by \code{itemCategories}). That is, the created
#' constraints assure that the number of items of each category per test form is either
#' (a) smaller or equal than (\code{operator = "<="}), (b) equal to
#' (\code{operator = "="}), or (c) greater than or equal to (\code{operator = ">="})
#' the corresponding \code{targetValues}.
#'
#'
#' @inheritParams itemValuesConstraint
#' @param itemCategories a factor representing the categories/grouping of the items
#' @param targetValues an integer vector representing the target number per category.
#'  The order of the target values should correspond with the order of the levels
#'  of the factor in \code{itemCategory}.
#'
#' @return A object of class \code{"constraint"}.
#'
#' @examples
#' ## constraints to make sure that there are at least 3 items of each item type
#' ## in each test form
#' nItems <- 30
#' item_type <- factor(sample(1:3, size = nItems, replace = TRUE))
#' itemCategoryConstraint(2, item_type, ">=", targetValues = c(1, 3, 2))
#'
#'@export
itemCategoryConstraint <- function(nForms, itemCategories,
                                   operator = c("<=", "=", ">="), targetValues,
                                   whichForms = seq_len(nForms),
                                   info_text = NULL,
                                   itemIDs = names(itemCategories)){

  operator <- match.arg(operator)

  # itemCategories should be a factor
  if(!is.factor(itemCategories)) stop("'itemCategories' should be a factor.")

  # itemValues should have length equal to itemIDs
  if(!is.null(itemIDs) && length(itemCategories) != length(itemIDs)) stop("The length of 'itemCategories' and 'itemIDs' should be identical.")

  # the number of levels should be equal to the number of targetValues
  levels <- levels(itemCategories)
  nLevels <- nlevels(itemCategories)
  if(nLevels != length(targetValues)) stop("The number of 'targetValues' should correspond with the number of levels in 'itemCategories'.")


  # choose info_text for info
  if(is.null(info_text)) info_text <- paste0(deparse(substitute(itemCategories)),
                                             operator, targetValues)

  if(length(info_text) == 1) info_text <- paste0(info_text, operator, targetValues)

  if(length(info_text) != nLevels) stop("'info_text' should be a character string of length equal to to the number of levels in 'itemCategories'.")

  do.call(combineConstraints, lapply(seq_len(nLevels), function(levelNr){
    itemValuesConstraint(nForms, 1 * (itemCategories == levels[levelNr]),
                         operator, targetValues[levelNr], whichForms, info_text[levelNr],
                         itemIDs)
  }))
}
