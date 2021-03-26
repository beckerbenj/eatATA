#############################################################################
#' Inspect a \code{useSolver} output
#'
#' Process a \code{useSolver} output of a successfully solved optimization problem to a list so it becomes humanly readable.
#'
#' This function merges the initial item pool information in \code{items} to the solver output in \code{solverOut}.
#' Relevant columns can be selected via \code{colNames}. Column sums within test forms are calculated if possible and
#' if \code{colSum} is set to \code{TRUE}.
#'
#'@param solverOut Object created by \code{useSolver} function.
#'@param items Original \code{data.frame} containing information on item level.
#'@param idCol Column name in \code{items} containing item IDs. These will be used for matching to the solver output.
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
#' usage <- itemUsageConstraint(nForms = 2, operator = "=",
#'                              targetValue = 1, itemIDs = items$ID)
#' perForm <- itemsPerFormConstraint(nForms = 2, operator = "=",
#'                                   targetValue = 5, itemIDs = items$ID)
#' target <- minimaxObjective(nForms = 2,
#'                                itemValues = items$itemValues,
#'                                targetValue = 0, itemIDs = items$ID)
#' sol <- useSolver(allConstraints = list(usage, perForm, target),
#'                                   solver = "lpSolve")
#'
#' ## Inspect Solution
#' out <- inspectSolution(sol, items = items, idCol = 1, colNames = "itemValues")
#'
#'@export
inspectSolution <- function(solverOut, items, idCol, colNames = names(items), colSums = TRUE){
  illegal_names <- colNames[!colNames %in% names(items)]
  if(length(illegal_names) > 0) stop("The following 'colNames' are not columns in 'items': ",
                                     paste(illegal_names, collapse = ", "))
  if(!identical(nrow(solverOut$item_matrix), nrow(items))) stop("'items' and the solution in 'solverOut' have different numbers of rows.")
  if(is.character(idCol)){
    if(!idCol %in% names(items)) stop("'idCol' is not a column in 'items'.")
  } else {
    if(!idCol %in% seq_len(dim(items)[2])) stop("'idCol' is not a column number in 'items'.")
    idCol <- names(items)[idCol]
  }

  if(!identical(rownames(solverOut$item_matrix), as.character(items[, idCol]))) stop("'items' and the solution in 'solverOut' have different sets of itemIDs.")
  check_solverOut(solverOut)

  new_items <- appendSolution(solverOut, items = items[, unique(c(idCol, colNames)), drop = FALSE], idCol = idCol)

  formNames <- colnames(solverOut$item_matrix)
  block_list <- lapply(formNames, function(nam) {
    #browser()
    sep_rows <- new_items[new_items[, nam] == 1, colNames, drop = FALSE]
    if(nrow(sep_rows) == 0) return(sep_rows)
    #rownames(sep_rows) <- paste0("Item ", seq(nrow(sep_rows)))
    if(!colSums) return(sep_rows)

    sums <- rep(NA, ncol(sep_rows))
    for(i in seq(ncol(sep_rows))) {
      if(is.numeric(sep_rows[, i])) sums[i] <- sum(sep_rows[, i])
    }
    out <- rbind(sep_rows, sums)
    rownames(out)[nrow(out)] <- "Sum"
    out
  })
  names(block_list) <- formNames
  block_list
}
