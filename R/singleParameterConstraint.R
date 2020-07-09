

### Speed constraints
# ---------------------------------------------------------------------------------------------------
####
#############################################################################
#' Create single value constraints with a tolerance.
#'
#' tbd
#'
#'@param nForms Number of forms to be created.
#'@param nItems Number of items in the item pool.
#'@param itemValues tbd
#'@param targetValues tbd
#'@param tolerance tbd
#'
#'@return A sparse matrix.
#'
#'@examples
#' #tbd
#'
#'@export
singleParameterConstraint <- function(nForms, nItems, itemValues, targetValues = NULL, tolerance){
  if(is.null(targetValues)) {
    targetValues <- detTargetValue(nForms = nForms, itemValues = itemValues)
    tolerance -0.5 ## not correct if targetValue is an integer, but should still work
  }

  M <- nForms*nItems
  rbind(
    Matrix::sparseMatrix(i = c(rep(1:nForms, each = nItems), 1:nForms, 1:nForms, 1:nForms),
                 j = c(1:M, rep(M+1, nForms), rep(M+2, nForms), rep(M+3, nForms)),
                 x = c(rep(itemValues, times = nForms), rep(0, nForms), rep(c(-1), each = nForms), rep(targetValues + tolerance, nForms))),
    Matrix::sparseMatrix(i = c(rep(1:nForms, each = nItems), 1:nForms, 1:nForms, 1:nForms),
                 j = c(1:M, rep(M+1, nForms), rep(M+2, nForms), rep(M+3, nForms)),
                 x = c(rep(itemValues, times = nForms), rep(0, nForms), rep(c(+1), each = nForms), rep(targetValues - tolerance, nForms)))
  )}


# determine target value automatically based on empirical frequency of kategory
detTargetValue <- function(nForms, itemValues) {
  stopifnot(identical(sort(unique(itemValues)), c(0, 1)) || identical(sort(unique(itemValues)), 1))

  if(sum(itemValues) %% nForms != 0) {
    return((sum(itemValues) %/% nForms) + 0.5)
  }
  (sum(itemValues) / nForms)

}
