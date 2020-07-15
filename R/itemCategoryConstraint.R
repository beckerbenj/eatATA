#' Create item category constraints.
#'
#' Create constraints related to item categories/groupings (as
#' represented by \code{itemCategories}). That is, the created
#' constraints assure that the number of items of each category per test form is either
#' (a) smaller or equal than (\code{operator = "<="}), (b) equal to
#' (\code{operator = "="}), or (c) greater or equal than (\code{operator = ">="})
#' the corresponding \code{targetValues}.
#'
#'
#'@param nForms Number of forms to be created.
#'@param nItems Number of items in the item pool.
#'@param itemCategory a factor representing the categories/grouping of the items
#'@param operator a character indicating which operator should be used in the
#'  constraints, with three possible values: \code{"<="}, \code{"="},
#'  or \code{">="}. See details for more information.
#'@param targetValues an integer vector representing the target number per category.
#'  The order of the target values should correspond with the order of the levels
#'  of the factor in \code{itemCategory}.
#'
#'@return A sparse matrix.
#'
#'@examples
#' ## constraints to make sure that there are at least 3 items of each item type
#' ## in each test form
#' nItems <- 30
#' item_type <- factor(sample(1:3, size = nItems, replace = TRUE))
#' itemCategoryConstraint(2, nItems, item_type, ">=", targetValues = c(3, 3, 3))

#'
#'@export
itemCategoryConstraint <- function(nForms, nItems, itemCategories, operator = c("<=", "=", ">="), targetValues){


  operator <- match.arg(operator)

  # itemCategories should be a factor
  if(!is.factor(itemCategories)) stop("'itemCategories' should be a factor.")

  # some arguments should be of lenght 1
  check <- sapply(list(nForms, nItems, operator), length) == 1
  if(any(!check)) stop("The following arguments should have length 1: 'nForms', 'nItems', 'operator'.")

  # itemValues should have length equal to nItems
  if(length(itemCategories) != nItems) stop("The lenght of 'itemCategories' should be equal to 'nItems'.")

  # the number of levels should be equal to the number of targetValues
  levels <- levels(itemCategories)
  nLevels <- nlevels(itemCategories)
  if(nLevels != length(targetValues)) stop("The number of 'targetValues' should correspond with the number of levels in 'itemCategories'.")


  do.call(rbind, lapply(seq_len(nLevels), function(levelNr){
    itemValuesConstraint(nForms, nItems, 1 * (itemCategories == levels[levelNr]), operator, targetValues[levelNr])
  }))
}
