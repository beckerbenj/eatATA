#############################################################################
#' Inspect \code{useSolver} output
#'
#' Process a \code{useSolver} output of a successfully solved optimization problem to a list so it becomes humanly readable.
#'
#'
#'@param solverOut Object created by \code{useSolver} function.
#'@param items Original \code{data.frame} containing information on item level.
#'@param colNames Which columns should be used from the \code{items} \code{data.frame}?
#'@param colSums Should column sums be calculated in the output? Only works if all columns are numeric.
#'
#'@return A \code{list} with assembled blocks as entries. Rows are the individual items. A final row is added, containing
#'the sums of each column.
#'
#'@examples
#' ## Example item pool
#' items <- data.frame(ID = 1:10,
#' itemValues = c(-4, -4, -2, -2, -1, -1, 20, 20, 0, 0))
#'
#' ## Test Assembly
#' usage <- itemUsageConstraint(nForms = 2, nItems = 10, operator = "=", targetValue = 1)
#' perForm <- itemsPerFormConstraint(nForms = 2, nItems = 10, operator = "=", targetValue = 5)
#' target <- itemTargetConstraint(nForms = 2, nItems = 10,
#'                                itemValues = items$itemValues,
#'                                targetValue = 0)
#' sol <- useSolver(allConstraints = list(usage, perForm, target),
#'                                   nForms = 2, nItems = 10, solver = "lpSolve")
#'
#' ## Inspect Solution
#' out <- inspectSolution(sol, items = items, colNames = "itemValues")
#'
#'@export
inspectSolution <- function(solverOut, items, colNames, colSums = TRUE){
  illegal_names <- colNames[!colNames %in% names(items)]
  if(length(illegal_names) > 0) stop("The following 'colNames' are not columns in 'items': ",
                                     paste(illegal_names, collapse = ", "))
  if(!identical(nrow(solverOut$item_matrix), nrow(items))) stop("'items' and the solution in 'solverOut' have different numbers of rows.")
  new_items <- data.frame(items[, colNames], solverOut$item_matrix)
  names(new_items) <- c(colNames, names(solverOut$item_matrix))

  block_list <- lapply(paste0("block_", seq(ncol(solverOut$item_matrix))), function(nam) {
    #browser()
    sep_rows <- new_items[new_items[, nam] == 1, colNames, drop = FALSE]
    if(nrow(sep_rows) == 0) return(sep_rows)
    rownames(sep_rows) <- paste0("Item ", seq(nrow(sep_rows)))
    if(!colSums) return(sep_rows)
    sums <- colSums(sep_rows)
    out <- rbind(sep_rows, sums)
    rownames(out)[nrow(out)] <- "Sum"
    out
  })
  names(block_list) <- paste0("block_", seq(ncol(solverOut$item_matrix)))
  block_list
}
