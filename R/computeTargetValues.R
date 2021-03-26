#' Compute target values based on the item pool.
#'
#' Compute target values for item values/categories based on the number
#' of items in the item pool, the number of test forms to assemble and the number
#' of items in each test form (i.e., test length).
#'
#' Both for numerical and categorical item values, the target values are the item
#' pool average scaled by the ratio of items in the forms and items in the item
#' pool. The behavior of the function changes depending on the class of
#' \code{itemValues}.
#'
#' When \code{itemValues} is a numerical vector, an when \code{allowedDeviation}
#' is \code{NULL} (the default), only one target value is computed. This value
#' could be used in the \code{targetConstraint}-function. Otherwise (i.e.,
#' \code{allowedDeviation} is a numerical value), the target is computed, but a
#' minimal and a maximal (target)value are returned, based on the allowed
#' deviation. When \code{relative == TRUE} the allowed deviation should be
#' expressed as a proportion. In that case the minimal and maximal values are
#' a computed proportionally.
#'
#' When \code{itemValues} is a \code{factor}, it is assumed that the item values
#' are item categories, and hence only whole valued frequencies are returned.
#' To be more precise, a matrix with the minimal and maximal target frequencies
#' for every level of the factor are returned. When \code{allowedDeviation}
#' is \code{NULL}, the difference between the minimal and maximal value is
#' one (or zero). As a consequence, dummy-item values are best specified as a
#' factor (see examples).
#
#' @inheritParams itemValuesConstraint
#' @inheritParams itemCategoryConstraint
#' @param allowedDeviation Numeric value of length 1. How much deviance is allowed from target values?
#' @param relative Is the \code{allowedDeviation} expressed as a proportion?
#' @param testLength to be documented.
#'
#' @return a vector or a matrix with target values (see details)
#'
#' @examples
#' ## Assume an item pool with 50 items with random item information values (iif) for
#' ## a given ability value.
#' set.seed(50)
#' itemInformations <- runif(50, 0.5, 3)
#'
#' ## The target value for the test information value (i.e., sum of the item
#' ## informations) when three test forms of 10 items are assembled is:
#' computeTargetValues(itemInformations, nForms = 3, testLength = 10)
#'
#' ## The minimum and maximum test iformation values for an allowed deviation of
#' ## 10 percent are:
#' computeTargetValues(itemInformations, nForms = 3, allowedDeviation = .10,
#'    relative = TRUE, testLength = 10)
#'
#'
#' ## items_vera$MC is dummy variable indication which items in the pool are multiple choise
#' str(items_vera$MC)
#'
#' ## when used as a numerical vector, the dummy is not treated as a categorical
#' ## indicator, but rather as a numerical value.
#' computeTargetValues(items_vera$MC, nForms = 14)
#' computeTargetValues(items_vera$MC, nForms = 14, allowedDeviation = 1)
#'
#' ## Therefore, it is best to convert dummy variables into a factor, so that
#' ## automatically freqyencies are returned
#' MC_factor <- factor(items_vera$MC, labels = c("not MC", "MC"))
#' computeTargetValues(MC_factor, nForms = 14)
#' computeTargetValues(MC_factor, nForms = 3)
#'
#' ## The computed minimum and maximum frequencies can be used to create contstraints.
#' MC_ranges <- computeTargetValues(MC_factor, nForms = 3)
#' itemCategoryRangeConstraint(3, MC_factor, range = MC_ranges)
#'
#' ## When desired, the automatically computed range can be adjusted by hand. This
#' ##  can be of use when only a limited set of the categories should be constrained.
#' ##  For instance, when only the multiple-choice items should be constrained, and
#' ##  the non-multiple-choice items should not be constrained, the minimum and
#' ##  maximum value can be set to a very small and a very high value, respectively.
#' ##  Or to other sensible values.
#' MC_ranges["not MC", ] <- c(0, 40)
#' MC_ranges
#' itemCategoryRangeConstraint(3, MC_factor, range = MC_ranges)
#'
#' @export
computeTargetValues <- function(itemValues, nForms, testLength = NULL,
                                allowedDeviation = NULL, relative = FALSE)
  UseMethod("computeTargetValues", itemValues)

#' @describeIn computeTargetValues compute target values
#' @export
computeTargetValues.default <- function(itemValues, nForms, testLength = NULL,
                                        allowedDeviation = NULL, relative = FALSE) {

  target <- 'if'(is.null(testLength),
                 sum(itemValues) / nForms,
                 mean(itemValues) * testLength)

  if(is.null(allowedDeviation)) return(target)
  else {if(relative) {
    if(allowedDeviation <= 0 | allowedDeviation >= 1) stop("When 'relative == TRUE' the 'allowedDeviation' should be expressed as a proportion between 0 and 1.")

    # change allowedDeviation based on relative deviation
    allowedDeviation <- target * allowedDeviation
    }
    return(c(min = target - allowedDeviation, max = target + allowedDeviation))
  }
}


#' @describeIn computeTargetValues compute target frequencies for item categories
#' @export
computeTargetValues.factor <- function(itemValues, nForms, testLength = NULL,
                                       allowedDeviation = NULL, relative = FALSE) {

  # the number of levels should be equal to the number of 'allowedDeviations'
  levels <- levels(itemValues)
  nLevels <- nlevels(itemValues)
  if(!is.null(allowedDeviation) & nLevels != length(allowedDeviation))
    stop("The number of 'allowedDeviations' should correspond with the number of levels in 'itemValues'.")

  targetFrequencies <- do.call(rbind, lapply(seq_len(nLevels), function(levelNr){
    if (is.null(allowedDeviation)){
      target <- computeTargetValues(1 * (itemValues == levels[levelNr]), nForms,
                          testLength)
      c(min = floor(target), max = ceiling(target))
    } else {
      targets <- computeTargetValues(1 * (itemValues == levels[levelNr]), nForms,
                          testLength, allowedDeviation[levelNr], relative)
      c(ceiling(targets["min"]), floor(targets["max"]))
    }
  }))

  dimnames(targetFrequencies) <- list(levels, c("min", "max"))
  targetFrequencies
}
