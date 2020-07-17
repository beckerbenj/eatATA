
####
#############################################################################
#' Create optimization constraints.
#'
#' tbd
#'
#'@param nForms Number of forms to be created.
#'@param nItems Number of items in the item pool.
#'@param itemValues tbd
#'@param targetValues tbd
#'@param thetaPoints tbd
#'@param relative tbd
#'@param bWidth tbd
#'
#'@return A sparse matrix.
#'
#'@examples
#' #tbd
#'
#'@export
targetConstraint <- function(nForms, nItems, itemValues, targetValues, thetaPoints,
                             relative = TRUE, bWidth = 0){
  M <- nForms*nItems
  nThPts <- dim(thetaPoints)[1]
  objWeight <- if(bWidth==0){1} else {0}

  do.call(rbind, lapply(1:nThPts, function(pt){
    R <- if(relative){targetValues[pt]} else {1}                        # relative : R = TargetValues[pt]
    rbind(
      Matrix::sparseMatrix(i = c(rep(1:nForms, each = nItems),
                         1:nForms                         , 1:nForms                  , 1:nForms),
                   j = c(1:M,
                         rep(M+1, nForms)                 , rep(M+2, nForms)          , rep(M+3, nForms)),
                   x = c(rep(itemValues[pt,]/R, times = nForms),
                         rep(c(-objWeight), each = nForms), rep(c(-1), each = nForms), rep(targetValues[pt]/R + bWidth, nForms))),

      Matrix::sparseMatrix(i = c(rep(1:nForms, each = nItems),
                         1:nForms                         , 1:nForms                  , 1:nForms),
                   j = c(1:M,
                         rep(M+1, nForms)                 , rep(M+2, nForms)          , rep(M+3, nForms)),
                   x = c(rep(itemValues[pt,]/R, times = nForms),
                         rep(c(+objWeight), each = nForms), rep(c(+1), each = nForms), rep(targetValues[pt]/R - bWidth, nForms))))
  }))
}


