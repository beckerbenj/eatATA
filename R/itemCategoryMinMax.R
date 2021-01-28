#' Create item category constraints with minimum and maximum.
#'
#' \code{itemCategoriesRange}, \code{itemCategoriesMin}, and \code{itemCategoriesMax}
#' create constraints related to item categories/groupings (as
#' represented by \code{itemCategories}). That is, the created
#' constraints assure that the number of items of each category per test form is either
#' smaller or equal than the specified \code{max}, greater than or equal to \code{min}
#' or both \code{range}.
#'
#' \code{itemCategoriesDeviation} also constrains the minimal and the maximal value
#' of the number of items of each category per test form, but based on chosen
#' \code{targetValues}, and maximal allowed deviations (i.e., \code{allowedDeviation})
#' from those \code{targetValues}.
#'
#'
#' @inheritParams itemValuesConstraint
#' @inheritParams itemCategoryConstraint
#' @inheritParams itemValuesRange
#' @param range a matrix with two columns representing the the minimal and the
#'   maximum frequency of the items from each level/category \code{itemCategories}
#'
#' @return A sparse matrix.
#'
#' @examples
#' ## constraints to make sure that there are at least 2 and maximally 4
#' ##  items of each item type in each test form
#' nItems <- 30
#' item_type <- factor(sample(1:3, size = nItems, replace = TRUE))
#' itemCategoryRange(2, item_type, range = cbind(min = rep(2, 3), max = rep(4, 3)))
#'
#' ## or alternatively
#' itemCategoryDeviation(2, item_type, targetValues = rep(3, 3), allowedDeviation = rep(4, 3))
#'
#' @export
itemCategoryRange <- function(nForms, itemCategories, range,
                              whichForms = seq_len(nForms),
                              info_text = NULL,
                              itemIDs = names(itemCategories)){

  if(!is.matrix(range) || dim(range)[1] != nlevels(itemCategories) || dim(range)[2] != 2) stop("'range' should be a matrix with two columns (minimum and maximum frequencies) and the number of rows equal to the number of levels in 'itemCategories'.")
  range <- as.matrix(range, ncol = 2)

  # min should be smaller than max
  if(any(range[,2] < range[,1])) stop("The values in the first column of 'range' should be smaller than the values in the second column of 'range'.")

  # choose info_text for info
  if(is.null(info_text)) info_text <- deparse(substitute(itemCategories))

  combine2Constraints(
    itemCategoryConstraint(nForms, itemCategories, operator = ">=",
                           targetValues = range[,1], whichForms,
                           info_text, itemIDs),
    itemCategoryConstraint(nForms, itemCategories, operator = "<=",
                           targetValues = range[,2], whichForms,
                           info_text, itemIDs)
  )
}

#' @describeIn itemCategoryRange constrain minimum value
#' @export
itemCategoryMin <- function(nForms, itemCategories, min,
                            whichForms = seq_len(nForms),
                            info_text = NULL,
                            itemIDs = names(itemCategories)){

  # choose info_text for info
  if(is.null(info_text)) info_text <- deparse(substitute(itemCategories))

  itemCategoryConstraint(nForms, itemCategories, operator = ">=",
                         targetValues = min, whichForms,
                         info_text, itemIDs)
}


#' @describeIn itemCategoryRange constrain maximum value
#' @export
itemCategoryMax <- function(nForms, itemCategories, max,
                            whichForms = seq_len(nForms),
                            info_text = NULL,
                            itemIDs = names(itemCategories)){

  # choose info_text for info
  if(is.null(info_text)) info_text <- deparse(substitute(itemCategories))

  itemCategoryConstraint(nForms, itemCategories, operator = "<=",
                         targetValues = max, whichForms,
                         info_text, itemIDs)
}


#' @describeIn itemCategoryRange constrain the distance form the \code{targetValues}
#' @export
itemCategoryDeviation <- function(nForms, itemCategories,
                                  targetValues, allowedDeviation,
                                  relative = FALSE,
                                  whichForms = seq_len(nForms),
                                  info_text = NULL,
                                  itemIDs = names(itemCategories)){

  # choose info_text for info
  if(is.null(info_text)) info_text <- deparse(substitute(itemCategories))

  # if relative == TRUE, compute the absolute allowed Deviation
  allowedDeviation <- 'if'(relative, targetValues * allowedDeviation, allowedDeviation)
  itemCategoryRange(nForms, itemCategories,
                    range = cbind(targetValues - allowedDeviation,
                                  targetValues + allowedDeviation),
                    whichForms,
                    info_text, itemIDs)
}
