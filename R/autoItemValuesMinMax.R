#' Create single value constraints with minimum and maximum.
#'
#' \code{\link{itemValuesDeviationConstraint}} creates constraints related to an item parameter/value. \code{autoItemValuesMixMax} automatically
#' determines the appropriate \code{targetValue} and then calls \code{\link{itemValuesDeviationConstraint}}. The function only works for
#' (dichotomous) dummy indicators with values 0 or 1.
#'
#' Two scenarios are possible when automatically determining the target value:
#' (a) Either items with the selected property could be exactly
#' distributed across test forms or (b) this is not possible. An example would be 2 test forms and 4 multiple choice items (a) or 2 test
#' forms and 5 multiple choice items (b). If (a), the tolerance level works exactly as one would expect. If (b) the tolerance level is
#' adapted, meaning that if tolerance level is 0 in example (b), allowed values are 2 or 3 multiple choice items per test form. For detailed documentation on how the minimum and maximum are calculated
#' see also \code{\link{computeTargetValues}}.
#'
#' @inheritParams itemValuesConstraint
#' @inheritParams computeTargetValues
#' @param verbose Should calculated values be reported?
#'
#' @return A sparse matrix.
#'
#' @examples
#' autoItemValuesMinMaxConstraint(2, itemValues = c(0, 1, 0, 1))
#'
#' @export
autoItemValuesMinMaxConstraint <- function(nForms, itemValues, testLength = NULL, allowedDeviation = NULL,
                                 relative = FALSE, verbose = TRUE, itemIDs = NULL){

  # compute the minimum and maximum values
  min_max <- computeTargetValues(itemValues, nForms, testLength = testLength,
                                 allowedDeviation = allowedDeviation, relative = relative)
  min_max <- round(min_max, 2)
  if(min_max[1] < 0) min_max[1] <- 0


  # if itemValues are actually categories (i.e., a factor)
  if(is.factor(itemValues)){
    out <- itemCategoryRangeConstraint(nForms, itemCategories = itemValues,
                       range = min_max, itemIDs = itemIDs)

    if(verbose){
      message("The minimum and maximum frequences per test form for each item category are")
      print(min_max)
    }

  } else { # if item values are numerical
    if(is.null(allowedDeviation)){  # no minimum or maximum, but only a target value is used
                                    # thus equality constraints are used rather than
                                    # inequality constraints
      out <- itemValuesConstraint(nForms, itemValues,
                           operator = "=", targetValue = min_max, itemIDs = itemIDs)
      if(verbose){
        message("The target value per test form is: ", min_max)
        }

    } else {  # constraints with respect to a minimum and maximum
      out <- itemValuesRangeConstraint(nForms, itemValues,
                       range = min_max, itemIDs = itemIDs)
      if(verbose){
        message("The minimum and maximum values per test form are: min = ",
                paste(min_max, collapse = " - max = "))
      }
    }
  }
  return(out)
}

## deprecated version
# autoItemValuesMinMaxConstraint <- function(nForms, nItems, itemValues, threshold, verbose = TRUE){
#   targetValue <- detTargetValue(nForms = nForms, itemValues = itemValues)
#   threshold <- threshold + 0.5 ## not correct if targetValue is an integer, but should still work
#
#   if(verbose) {
#     minV <- ceiling(targetValue - threshold)
#     maxV <- floor(targetValue + threshold)
#     possibleV <- seq(minV, maxV)
#     message("Target value: ", targetValue,"\t Values in range: ", paste(possibleV, collapse = ", "))
#   }
#
#   itemValuesThreshold(nForms = nForms, nItems = nItems, itemValues = itemValues,
#                       targetValue = targetValue, threshold = threshold)
# }
#
#
# # determine target value automatically based on empirical frequency of category
# detTargetValue <- function(nForms, itemValues) {
#   if(!identical(sort(unique(itemValues)), c(0, 1)) && !identical(sort(unique(itemValues)), 1)) {
#     stop("autoItemValuesMinMaxConstraint only works for (dichotomous) dummy indicators with values 0 and 1. See itemValuesM# inMax for more flexibility.")
#   }
#
#   if(sum(itemValues) %% nForms != 0) {
#     return((sum(itemValues) %/% nForms) + 0.5)
#   }
#   (sum(itemValues) / nForms)
#
# }
