#' Create single value constraints with minimum and maximum.
#'
#' \code{itemValuesRange}, \code{itemValuesMin}, and \code{itemValuesMax}
#' create constraints related to an item parameter/value. That is, the created
#' constraints assure that the sum of the \code{itemValues} is smaller than or equal
#' to \code{max}, greater than or equal to \code{min}, or both \code{range}.
#'
#' \code{itemValuesDeviation} also constrains the minimal and the maximal value
#' of the sum of the \code{itemValues}, but based on a chosen
#' and a maximal allowed deviation (i.e., \code{allowedDeviation}) from that \code{targetValue}.
#'
#' @inheritParams itemValuesConstraint
#' @param min the minimal sum of the \code{itemValues} per test form
#' @param max the minimal sum of the \code{itemValues} per test form
#' @param range a vector with two values, the the minimal and the maximum sum of
#' the \code{itemValues} per test form, respectively
#' @param  allowedDeviation the maximum allowed deviation from the \code{targetValue}
#' @param relative a logical expressing whether or not the \code{allowedDeviation}
#'        should be interpreted as a proportion of the \code{targetValue}
#'
#' @return A sparse matrix.
#'
#' @examples
#' ## constraints to make sure that the sum of the item values (1:10) is between
#' ## 4 and 6
#' itemValuesRange (2, 10, 1:10, range(min = 4, max = 6))
#'
#' ## or alternatively
#' itemValuesDeviation (2, 10, 1:10, targetValue = 5, allowedDeviation = 1)
#'
#' @export
itemValuesRange <- function(nForms, nItems, itemValues, range){

  # min should be smaller than max
  if(range[2] < range[1]) stop("The first value of 'range' should be smaller than second value of 'range'.")

  rbind(
    itemValuesConstraint(nForms, nItems, itemValues, operator = ">=", targetValue = range[1]),
    itemValuesConstraint(nForms, nItems, itemValues, operator = "<=", targetValue = range[2])
  )
}

#' @describeIn itemValuesRange constrain minimum value
#' @export
itemValuesMin <- function(nForms, nItems, itemValues, min){
  itemValuesConstraint(nForms, nItems, itemValues, operator = ">=", targetValue = min)
}


#' @describeIn itemValuesRange constrain maximum value
#' @export
itemValuesMax <- function(nForms, nItems, itemValues, max){
  itemValuesConstraint(nForms, nItems, itemValues, operator = "<=", targetValue = max)
}


#' @describeIn itemValuesRange constrain the distance form the \code{targetValue}
#' @export
itemValuesDeviation <- function(nForms, nItems, itemValues, targetValue, allowedDeviation, relative = FALSE){

  # if relative == TRUE, compute the absolute allowed Deviation
  allowedDeviation <- 'if'(relative, targetValue * allowedDeviation, allowedDeviation)
  itemValuesRange(nForms, nItems, itemValues,
                  range = c(targetValue - allowedDeviation,
                            targetValue + allowedDeviation))
}


