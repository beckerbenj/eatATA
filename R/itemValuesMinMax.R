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
#' @return An object of class \code{"constraint"}.
#'
#' @examples
#' ## constraints to make sure that the sum of the item values (1:10) is between
#' ## 4 and 6
#' itemValuesRange (2, 1:10, range(min = 4, max = 6))
#'
#' ## or alternatively
#' itemValuesDeviation (2, 1:10, targetValue = 5, allowedDeviation = 1)
#'
#' @export
itemValuesRange <- function(nForms, itemValues, range,
                            whichForms = seq_len(nForms),
                            info_text = NULL,
                            itemIDs = names(itemValues)){

  # min should be smaller than max
  if(range[2] < range[1]) stop("The first value of 'range' should be smaller than second value of 'range'.")

  # choose info_text for info
  if(is.null(info_text)) info_text <- deparse(substitute(itemValues))

  combineConstraints(
    itemValuesConstraint(nForms, itemValues, operator = ">=",
                         targetValue = range[1], whichForms,
                         info_text = paste0(info_text, ">=", range[1]),
                         itemIDs),
    itemValuesConstraint(nForms, itemValues, operator = "<=",
                         targetValue = range[2], whichForms,
                         info_text = paste0(info_text, "<=", range[2]),
                         itemIDs)
  )
}

#' @describeIn itemValuesRange constrain minimum value
#' @export
itemValuesMin <- function(nForms, itemValues, min,
                          whichForms = seq_len(nForms),
                          info_text = NULL,
                          itemIDs = names(itemValues)){
  # choose info_text for info
  if(is.null(info_text)) info_text <- deparse(substitute(itemValues))

  itemValuesConstraint(nForms, itemValues, operator = ">=",
                       targetValue = min, whichForms = whichForms,
                       info_text = paste0(info_text, ">=", min),
                       itemIDs)
}


#' @describeIn itemValuesRange constrain maximum value
#' @export
itemValuesMax <- function(nForms, itemValues, max,
                          whichForms = seq_len(nForms),
                          info_text = NULL,
                          itemIDs = names(itemValues)){
  # choose info_text for info
  if(is.null(info_text)) info_text <- deparse(substitute(itemValues))

  itemValuesConstraint(nForms, itemValues, operator = "<=",
                       targetValue = max, whichForms = whichForms,
                       info_text = paste0(info_text, "<=", max),
                       itemIDs)
}


#' @describeIn itemValuesRange constrain the distance form the \code{targetValue}
#' @export
itemValuesDeviation <- function(nForms, itemValues,
                                targetValue, allowedDeviation,
                                relative = FALSE,
                                whichForms = seq_len(nForms),
                                info_text = NULL,
                                itemIDs = names(itemValues)){

  # if relative == TRUE, compute the absolute allowed Deviation
  allowedDeviation <- 'if'(relative, targetValue * allowedDeviation, allowedDeviation)

  # choose info_text for info
  if(is.null(info_text)) info_text <- deparse(substitute(itemValues))

  itemValuesRange(nForms, itemValues,
                  range = c(targetValue - allowedDeviation,
                            targetValue + allowedDeviation),
                  whichForms = whichForms, info_text = info_text,
                  itemIDs)
}


