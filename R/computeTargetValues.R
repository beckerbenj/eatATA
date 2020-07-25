#' Compute target values based on the item pool.
#'
#' Compute target values for item values/categories based on the number
#' of items in the item pool, the number of test forms to assemble and the number
#' of items in each test form (i.e., test length).
#'
#' Both for numerical and categorical item values, the target values are the item
#' pool average scaled by the ratio of items in the forms and items in the item
#' pool.
#'
#' When the \code{allowedDeviation} is \code{NULL} (the default), only one target
#' value is computed. Otherwise, the target is computed, but a minimal and a
#' maximal (target)value is returned, based on the allowed deviation. When
#' \code{relative == TRUE} the allowed deviation should be expressed as a
#' proportion. In that case the minimal and maximal values are a computed
#' proportionally.
#'
#' When \code{itemValues} is a \code{factor}, a matrix with the minimal and
#' maximal target frequencies for every level of the factor are returned.
#' When \code{allowedDeviation} is \code{NULL}, the difference between the
#' minimal and maximal value is one (or zero).
#
#' @inheritParams itemValuesConstraint
#' @inheritParams itemCategoryConstraint
#'
#'
#' @return a vector or a matrix with targetValues (see details)
#'
#'@examples
#'
#'
#'@export
computeTargetValues <- function(itemValues, ...)
  UseMethod("computeTargetValues", itemValues)

#' @describeIn computeTargetValues compute target values
#' @export
computeTargetValues.default <- function(itemValues, nForms, testLength = NULL,
                                        allowedDeviation = NULL, relative = FALSE, ...) {

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
                                       allowedDeviation = NULL, relative = FALSE, ...) {

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
