#############################################################################
#' Append a \code{useSolver} output
#'
#' Append a \code{useSolver} output of a successfully solved optimization problem to the initial item pool \code{data.frame}.
#'
#' This function merges the initial item pool information in \code{items} to the solver output in \code{solverOut}.
#'
#'@param solverOut Object created by \code{useSolver} function.
#'@param items Original \code{data.frame} containing information on item level.
#'@param idCol Column name in \code{items} containing item IDs. These will be used for matching to the solver output.
#'
#'@return A \code{data.frame}.
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
#'                                   nForms = 2, itemIDs = items$ID, solver = "lpSolve")
#'
#' ## Append Solution to existing item information
#' out <- appendSolution(sol, items = items, idCol = "ID")
#'
#'@export
appendSolution <- function(solverOut, items, idCol){
  if(!identical(nrow(solverOut$item_matrix), nrow(items))) stop("'items' and the solution in 'solverOut' have different numbers of rows.")
  if(!idCol %in% names(items)) stop("'idCol' is not a column in 'items'.")
  if(!identical(rownames(solverOut$item_matrix), as.character(items[, idCol]))) stop("'items' and the solution in 'solverOut' have different sets of itemIDs.")
  check_solverOut(solverOut)

  new_items <- data.frame(items, solverOut$item_matrix)
  names(new_items) <- c(names(items), names(solverOut$item_matrix))

  new_items
}
