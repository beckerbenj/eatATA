

##----------------------------------------------------------------
## nrItInForm.R
##----------------------------------------------------------------

## noItemOverlap.R is used as a source file in the simulation studies for the manuscript
## entitled: "Multidimensional Linear Test Assembly Using Mixed Integer Linear
## Programming".
## This file creates a funcion that writes a sparse matrix that can be used in the
## writeMILP function (sourse-file writeMILP.R)
## The resulting sparse matrix is a combination of (1) the matrix A
## (dim = c(nrForms, nrItems * nrForms + 1)) with weights for all the MILP-
## variables (i.e, the left hand side of the constraints), (2) a vector (length nrForms)
## with the sign of the constraints represented by a number (-1 = leq, 0 = eq, 1 = geq),
## and (3) a vector d (length nrItems) with the right hand side of the constraints.

####
#############################################################################
#' Create nomber of items per test form constraints.
#'
#' tbd
#'
#'@param nForms Number of forms to be created.
#'@param nItems Number of items in the item pool.
#'@param sign tbd
#'@param nrItems Fixed number of items per test form.
#'
#'@return A sparse matrix.
#'
#'
#'@examples
#' #tbd
#'
#'@export
nrItInFormConstraint <- function(nForms, nItems, sign, nrItems){
  M <- nForms*nItems
  Matrix::sparseMatrix(i = c(rep(1:nForms, each = nItems), 1:nForms           , 1:nForms),
               j = c(1:(M)                       , rep(M+2, nForms)   , rep(M+3, nForms)),
               x = c(rep(1, M)                   , rep(sign, nForms)  , rep(nrItems, nForms)))
}
