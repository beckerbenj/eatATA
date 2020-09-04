
####
#############################################################################
#' Create optimization constraints.
#'
#' Create constraints that define the optimization goal of a automated test assembly problem.
#'
#'@param nForms Number of forms to be created.
#'@param nItems Number of items in the item pool.
#'@param itemValues Item parameter/values for which the sum per test form should be constrained
#'@param targetValue The target value to be used in the constraints.
#'
#'@return A sparse matrix.
#'
#'@examples
#' itemTargetConstraint(nForms = 2, nItems = 4, c(1, 0.5, 1.5, 2), targetValue = 1)
#'
#'@export
itemTargetConstraint <- function(nForms, nItems, itemValues, targetValue){
  M <- nForms*nItems

  rbind(
    Matrix::sparseMatrix(i = c(rep(1:nForms, each = nItems),
                       1:nForms                         , 1:nForms                  , 1:nForms),
                 j = c(1:M,
                       rep(M+1, nForms)                 , rep(M+2, nForms)          , rep(M+3, nForms)),
                 x = c(rep(itemValues, times = nForms),
                       rep(c(-1), each = nForms), rep(c(-1), each = nForms), rep(targetValue, nForms))),

    Matrix::sparseMatrix(i = c(rep(1:nForms, each = nItems),
                       1:nForms                         , 1:nForms                  , 1:nForms),
                 j = c(1:M,
                       rep(M+1, nForms)                 , rep(M+2, nForms)          , rep(M+3, nForms)),
                 x = c(rep(itemValues, times = nForms),
                       rep(c(1), each = nForms), rep(c(+1), each = nForms), rep(targetValue, nForms)))
  )
}


### original function (deprecated)
targetConstraint <- function(nForms, nItems, itemValues, targetValues, thetaPoints,
                             relative = TRUE, bWidth = 0){
  M <- nForms*nItems
  nThPts <- dim(thetaPoints)[1]
  objWeight <- if(bWidth==0){1} else {0}

  do.call(rbind, lapply(1:nThPts, function(pt){
    R <- if(relative){targetValues[pt]} else {1}                        # relative : R = TargetValues[pt]
    rbind(
      Matrix::sparseMatrix(i = c(rep(1:nForms, each = nItems),               1:nForms                          , 1:nForms                  , 1:nForms),
                           j = c(1:M,                                        rep(M+1, nForms)                  , rep(M+2, nForms)          , rep(M+3, nForms)),
                           x = c(rep(itemValues[pt,]/R, times = nForms),     rep(c(-objWeight), each = nForms) , rep(c(-1), each = nForms) , rep(targetValues[pt]/R + bWidth, nForms))),

      Matrix::sparseMatrix(i = c(rep(1:nForms, each = nItems),               1:nForms                          , 1:nForms                  , 1:nForms),
                           j = c(1:M,                                        rep(M+1, nForms)                  , rep(M+2, nForms)          , rep(M+3, nForms)),
                           x = c(rep(itemValues[pt,]/R, times = nForms),     rep(c(+objWeight), each = nForms) , rep(c(+1), each = nForms) , rep(targetValues[pt]/R - bWidth, nForms))))
  }))
}

