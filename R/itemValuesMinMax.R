#' Create single value constraints with minimum and maximum.
#'
#' Create constraints related to an item parameter/value. That is, the created
#' constraints assure that the sum of the \code{itemValues} is smaller than or equal
#' to \code{max}, greater than or equal to \code{min}, or both.
#'
#' \code{itemValuesThreshold} also constrains the minimal and the maximal value
#' of the sum of the \code{itemValues}, but based on a chosen
#' and a maximal allowed deviation (i.e., \code{threshold}) from that \code{targetValue}.
#'
#' @inheritParams itemValuesConstraint
#' @param min the minimal sum of the \code{itemValues} per test form
#' @param max the minimal sum of the \code{itemValues} per test form
#' @param threshold the maximum allowed difference from the \code{targetValue}
#'
#' @return A sparse matrix.
#'
#' @examples
#' ## constraints to make sure that the sum of the item values (1:10) is between
#' ## 4 and 6
#' itemValuesMinMax (2, 10, 1:10, min = 4, max = 6)
#'
#' ## or alternatively
#' itemValuesThreshold (2, 10, 1:10, targetValue = 5, threshold = 1)
#'
#' @export
itemValuesMinMax <- function(nForms, nItems, itemValues, min, max){

  # min should be smaller than max
  if(max < min) stop("'min' should be smaller than 'max'.")

  rbind(
    itemValuesConstraint(nForms, nItems, itemValues, operator = ">=", targetValue = min),
    itemValuesConstraint(nForms, nItems, itemValues, operator = "<=", targetValue = max)
  )
}

#' @describeIn itemValuesMinMax constrain minimum value
#' @export
itemValuesMin <- function(nForms, nItems, itemValues, min){
  itemValuesConstraint(nForms, nItems, itemValues, operator = ">=", targetValue = min)
}


#' @describeIn itemValuesMinMax constrain maximum value
#' @export
itemValuesMax <- function(nForms, nItems, itemValues, max){
  itemValuesConstraint(nForms, nItems, itemValues, operator = "<=", targetValue = max)
}


#' @describeIn itemValuesMinMax constrain the distance form the \code{targetValue}
#' @export
itemValuesThreshold <- function(nForms, nItems, itemValues, targetValue, threshold){
  itemValuesMinMax(nForms, nItems, itemValues, min = targetValue - threshold,
                   max = targetValue + threshold)
}


