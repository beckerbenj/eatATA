
##----------------------------------------------------------------
## noItemOverlap.R
##----------------------------------------------------------------

## noItemOverlap.R is used as a source file in the simulation studies for the manuscript
## entitled: "Multidimensional Linear Test Assembly Using Mixed Integer Linear
## Programming".
## This file creates a funcion that writes a sparse matrix that can be used in the
## writeMILP function (sourse-file writeMILP.R)
## The resulting sparse matrix is a combination of (1) the matrix A
## (dim = c(nrItems, nrItems * nrForms + 1)) with weights for all the MILP-
## variables (i.e, the left hand side of the constraints), (2) a vector (length nrItems)
## with the sign of the constraints represented by a number (-1 = leq, 0 = eq, 1 = geq),
## and (3) a vector d (length nrItems) with the right hand side of the constraints.

####
#############################################################################
#' Create no item overlap constraints.
#'
#' tbd
#'
#'@param nForms Number of forms to be created.
#'@param nItems Number of items in the item pool.
#'@param sign tbd
#'
#'@return A sparse matrix.
#'
#'@examples
#' #tbd
#'
#'@export
noItemOverlapConstraint <- function(nForms, nItems, sign){
  M <- nForms*nItems
  Matrix::sparseMatrix(i = c(rep(1:nItems, times = nForms), 1:nItems           , 1:nItems),
               j = c(1:(M)                        , rep(M+2, nItems)   , rep(M+3, nItems)),
               x = c(rep(1, M)                    , rep(sign, nItems)    , rep(1, nItems)))
}
