

####
#############################################################################
#' Use complete item pool.
#'
#' Currently not in use as noItemOverlapConstraint does this. Development incomplete!
#'
#'@param nForms Number of forms to be created.
#'@param nItems Number of items in the item pool.
#'
#'@return A sparse matrix.
#'
#'@examples
#' #tbd
#'
#'@export
itemPoolConstraint <- function(nForms, nItems){
  M <- nForms*nItems
  Matrix::sparseMatrix(i = c(rep(1:nItems, times = nForms), 1:nItems           , 1:nItems),
                       j = c(1:(M)                        , rep(M+2, nItems)   , rep(M+3, nItems)),
                       x = c(rep(1, M)                    , rep(0, nItems)    , rep(1, nItems)))
}
