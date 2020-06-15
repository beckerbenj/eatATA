

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
singleParameterConstraint <- function(nForms, nItems, itemValues, targetValues, tolerance){
  M <- nForms*nItems
  rbind(
    Matrix::sparseMatrix(i = c(rep(1:nForms, each = nItems), 1:nForms, 1:nForms, 1:nForms),
                 j = c(1:M, rep(M+1, nForms), rep(M+2, nForms), rep(M+3, nForms)),
                 x = c(rep(itemValues, times = nForms), rep(0, nForms), rep(c(-1), each = nForms), rep(targetValues + tolerance, nForms))),
    Matrix::sparseMatrix(i = c(rep(1:nForms, each = nItems), 1:nForms, 1:nForms, 1:nForms),
                 j = c(1:M, rep(M+1, nForms), rep(M+2, nForms), rep(M+3, nForms)),
                 x = c(rep(itemValues, times = nForms), rep(0, nForms), rep(c(+1), each = nForms), rep(targetValues - tolerance, nForms)))
  )}


