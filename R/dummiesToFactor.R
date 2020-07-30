#############################################################################
#' Convert dummy variables to factor.
#'
#' Convert multiple dummy variables into a single factor variable.
#'
#' The content of a single factor variable can alternatively be stored in multiple dichotomous dummy variables coded with \code{0}/\code{1} or \code{NA}/\code{1}. \code{1} always has to refer to "this category applies".
#'
#'@param dat A \code{data.frame}.
#'@param dummies Character vector containing the names of the dummy variables in the \code{data.frame}.
#'@param facVar Name of the factor variable, that should be created.
#'
#'@return A \code{data.frame} containing the newly created factor.
#'
#'@examples
#' # Example data set
#' tdat <- data.frame(ID = 1:3, d1=c(1, 0, 0), d2 = c(0, 1, 0), d3 = c(0, 0, 1))
#'
#' dummiesToFactor(tdat, dummies = c("d1", "d2", "d3"), facVar = "newFac")
#'
#'@export
dummiesToFactor <- function(dat, dummies, facVar) {
  if(!is.data.frame(dat)) stop("'dat' needs to be a data.frame.")
  if(!is.character(dummies)) stop("'dummies' needs to be a character vector.")
  if(!all(dummies %in% names(dat))) stop("All 'dummies' have to be columns in 'dat'.")
  if(!is.character(facVar) || length(facVar) != 1) stop("'facVar' needs to be a character vector of length 1.")
  if(facVar %in% names(dat)) stop("'facVar' is an existing column in 'dat'.")

  dummie_dat <- dat[, dummies, drop = FALSE]
  if(!all(unlist(dummie_dat) %in% c(0, 1, NA))) stop("All values in the 'dummies' columns have to be 0, 1 or NA.")
  dummie_dat[is.na(dummie_dat)] <- 0
  if(any(rowSums(dummie_dat) > 1)) stop("For some rows, more than 1 dummy variable is 1.")

  fac <- factor(names(dummie_dat)[max.col(dummie_dat)])
  out <- cbind(dat, fac)
  names(out)[ncol(dat) + 1] <- facVar
  out
}
