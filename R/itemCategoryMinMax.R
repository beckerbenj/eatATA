#' Create item category constraints with minimum and maximum.
#'
#' Create constraints related to item categories/groupings (as
#' represented by \code{itemCategories}). That is, the created
#' constraints assure that the number of items of each category per test form is either
#' smaller or equal than the corresponding \code{max}, greater than or equal to \code{min} or both.
#'
#' \code{itemCategoriesThreshold} also constrains the minimal and the maximal value
#' of the number of items of each category per test form, but based on chosen
#' \code{targetValues}, and maximal allowed deviations (i.e., \code{threshold})
#' from those \code{targetValues}.
#'
#'
#' @inheritParams itemValuesConstraint
#' @inheritParams itemCategoryConstraint
#' @inheritParams itemValuesMinMax
#' @param thresholds an integer vector representing the thresholds per category.
#'  The order of the thresholds should correspond with the order of the levels
#'  of the factor in \code{itemCategories}.
#'
#' @return A sparse matrix.
#'
#' @examples
#' ## constraints to make sure that there are at least 2 and maximally 4
#' ##  items of each item type in each test form
#' nItems <- 30
#' item_type <- factor(sample(1:3, size = nItems, replace = TRUE))
#' itemCategoryMinMax(2, nItems, item_type, min = rep(2, 3), max = rep(4, 3))
#'
#' ## or alternatively
#' itemCategoryThreshold(2, nItems, item_type, targetValues = rep(3, 3), thresholds = rep(4, 3))
#'
#' @export
itemCategoryMinMax <- function(nForms, nItems, itemCategories, min, max){

  # min should be smaller than max
  if(any(max <= min)) stop("'min' should be smaller than 'max'.")

  rbind(
    itemCategoryConstraint(nForms, nItems, itemCategories, operator = ">=", targetValues = min),
    itemCategoryConstraint(nForms, nItems, itemCategories, operator = "<=", targetValues = max)
  )
}

#' @describeIn itemCategoryMinMax constrain minimum value
#' @export
itemCategoryMin <- function(nForms, nItems, itemCategories, min){
  itemCategoryConstraint(nForms, nItems, itemCategories, operator = ">=", targetValues = min)
}


#' @describeIn itemCategoryMinMax constrain maximum value
#' @export
itemCategoryMax <- function(nForms, nItems, itemCategories, max){
  itemCategoryConstraint(nForms, nItems, itemCategories, operator = "<=", targetValues = max)
}


#' @describeIn itemCategoryMinMax constrain the distance form the \code{targetValues}
#' @export
itemCategoryThreshold <- function(nForms, nItems, itemCategories, targetValues, thresholds){
  itemCategoryMinMax(nForms, nItems, itemCategories, min = targetValues - thresholds,
                   max = targetValues + thresholds)
}
