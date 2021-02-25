####
#############################################################################
#' Create item exclusion tuples from matrix.
#'
#' If item exclusions are stored as a matrix, \code{matrixExclusionTuples} transforms this format into item pairs ('tuples').
#' Information on exclusions has to be coded as \code{1} (items are exclusive) and \code{0} (items are not exclusive).
#'
#' Exclusion tuples can be used by \code{\link{itemExclusionConstraint}} to set up exclusion constraints.
#'
#'@param exclMatrix A \code{data.frame} or \code{matrix} with information on item exclusiveness.
#'
#'@return A \code{data.frame} with two columns.
#'
#'@examples
#' # Example data.frame
#' exclDF <- data.frame(c(0, 1, 0, 0),
#'                      c(1, 0, 0, 1),
#'                      c(0, 0, 0, 0),
#'                      c(0, 1, 0, 0))
#'rownames(exclDF) <- colnames(exclDF) <- paste0("item_", 1:4)
#'
#' # Create tuples
#' matrixExclusionTuples(exclDF)
#'
#'
#'@export
matrixExclusionTuples <- function(exclMatrix) {
  if(!is.data.frame(exclMatrix) && !is.matrix(exclMatrix)) stop("'exclMatrix' needs to be a matrix or data.frame.")
  if(!identical(colnames(exclMatrix), rownames(exclMatrix))) stop("'exclMatrix' needs to have symmetrical row and column names.")

  exclMatrix <- as.matrix(exclMatrix)
  if(!all(exclMatrix %in% c(0, 1))) stop("'exclMatrix' must only contain 0 and 1.")
  if(!isSymmetric(exclMatrix)) stop("'exclMatrix' needs to be symmetrical.")

  exclTri <- exclMatrix
  for(co in seq(ncol(exclTri))) {
    exclTri[exclTri[, co] == 1, co] <- colnames(exclTri)[co]
  }

  excl_str <- data.frame(item = rownames(exclTri), excl = rep(NA, nrow(exclTri)))
  for(ro in seq(nrow(exclTri))) {
    excls <- exclTri[ro, ]
    if(any(excls != 0)) excl_str[ro, "excl"] <- paste(excls[excls != 0], collapse = ",")
  }

  itemTuples(items = excl_str, idCol = "item", infoCol = "excl", sepPattern = ",")
}
