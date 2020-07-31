#############################################################################
#' Convert dummy variables to factor.
#'
#' Convert multiple dummy variables into a single factor variable.
#'
#' The content of a single factor variable can alternatively be stored in multiple dichotomous dummy variables coded with \code{0}/\code{1} or \code{NA}/\code{1}. \code{1} always has to refer to "this category applies". The function requires factor levels to be exclusive (i.e. only one factor level applies per row.).
#'
#'@param dat A \code{data.frame}.
#'@param dummies Character vector containing the names of the dummy variables in the \code{data.frame}.
#'@param facVar Name of the factor variable, that should be created.
#'@param nameEmptyCategory a character of length 1 that defines the name of cases
#'  for which no dummy is equal to one.
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
dummiesToFactor <- function(dat, dummies, facVar, nameEmptyCategory = "_none_") {
  if(!is.data.frame(dat)) stop("'dat' needs to be a data.frame.")
  if(!is.character(dummies)) stop("'dummies' needs to be a character vector.")
  if(!all(dummies %in% names(dat))) stop("All 'dummies' have to be columns in 'dat'.")
  if(!is.character(facVar) || length(facVar) != 1) stop("'facVar' needs to be a character vector of length 1.")
  if(!is.character(nameEmptyCategory) || length(nameEmptyCategory) != 1) stop("'nameEmptyCategory' needs to be a character vector of length 1.")
  if(facVar %in% names(dat)) stop("'facVar' is an existing column in 'dat'.")
  if(nameEmptyCategory %in% dummies) stop("'nameEmptyCategory' is an existing category in 'dummies'.")

  if(!is.character(nameEmptyCategory) || length(nameEmptyCategory) != 1) stop("'nameEmptyCategory' needs to be a character vector of length 1.")

  dummie_dat <- dat[, dummies, drop = FALSE]
  if(!all(unlist(dummie_dat) %in% c(0, 1, NA))) stop("All values in the 'dummies' columns have to be 0, 1 or NA.")
  dummie_dat[is.na(dummie_dat)] <- 0
  illegal_rows <- which(rowSums(dummie_dat) > 1)
  if(length(illegal_rows) > 0) stop("For these rows, more than 1 dummy variable is 1: ",
                                    paste(illegal_rows, collapse = ", "))

  no_dummy_rows <- which(rowSums(dummie_dat) == 0)
  if(length(no_dummy_rows) > 0) {
    warning("For these rows, there is no dummy variable equal to 1: ",
            paste(no_dummy_rows, collapse = ", "),
            "\n",
            "A '", nameEmptyCategory, " 'category is created for these rows.")
    dummie_dat[, nameEmptyCategory] <- 0
    dummie_dat[no_dummy_rows, nameEmptyCategory] <- 1
  }


  fac <- factor(names(dummie_dat)[max.col(dummie_dat)])
  out <- cbind(dat, fac)
  names(out)[ncol(dat) + 1] <- facVar
  out
}
