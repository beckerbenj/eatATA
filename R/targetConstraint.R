

##----------------------------------------------------------------
## targetConstraint.R
##----------------------------------------------------------------

## noItemOverlap.R is used as a source file in the simulation studies for the manuscript
## entitled: "Multidimensional Linear Test Assembly Using Mixed Integer Linear
## Programming".
## This file creates a funcion that writes a sparse matrix that can be used in the
## writeMILP function (sourse-file writeMILP.R)
## The resulting sparse matrix is a combination of (1) the matrix A
## (dim = c(nrSets*nrForms, nrItems * nrForms + 1)) with weights for all the MILP-
## variables (i.e, the left hand side of the constraints), (2) a vector (length nrSets*nrForms)
## with the sign of the constraints represented by a number (-1 = leq, 0 = eq, 1 = geq),
## and (3) a vector d (length nrSets*nrForms) with the right hand side of the constraints.


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


