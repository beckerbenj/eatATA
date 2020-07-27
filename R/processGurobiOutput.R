#############################################################################
#' Process \code{gurobi} output
#'
#' Process a \code{gurobi} output of a successfully solved optimization problem so it becomes humanly readable.
#'
#' The output can either be transformed to a \code{data.frame} (optimal for writing to disk and re-importing into other programs) or to
#' a \code{list} (optimal for quick visual inspection.)
#'
#'@param gurobiObj Object created by \code{gurobi} solver.
#'@param items Original \code{data.frame} containing information on item level.
#'@param nForms Number of forms that have been created.
#'@param output Should the output be returned as a \code{data.frame} or a \code{list}?
#'
#'@return a \code{data.frame} or a \code{list}.
#'
#'@examples
#' ## using existing gurobi example
#' processGurobiOutput(gurobiExample, items = items, nForms = 2, output = "list")
#' processGurobiOutput(gurobiExample, items = items, nForms = 2, output = "data.frame")
#'
#' \dontrun{
#'
#' ## Full workflow
#' items <- data.frame(paste0("item", 1:10), stringsAsFactors = FALSE)
#'
#' ## setup constraints
#' # ...
#'
#' gurobi_model <- prepareConstraints(list(constraint1, constraint2, constraint3),
#'                                    nForms = 2, nItems = 10)
#'
#' gurobi_out <- gurobi(gurobi_model, params = list(TimeLimit = 30))
#'
#' processGurobiOutput(gurobi_out, items = items, nForms = 2, output = "list")
#' }
#'
#'@export
processGurobiOutput <- function(gurobiObj, items, nForms, output = "data.frame"){
  nItems <- nrow(items)
  block_ind <- 1:nForms
  names(block_ind) <- paste("form", block_ind, sep = "_")
  block_df <- as.data.frame(lapply(block_ind, function(x) {
    ind <- (x-1)*nItems + 1:nItems
    gurobiObj$x[ind]
  }))

  new_items <- cbind(items, block_df)

  if(output == "list") {
    new_items <- lapply(names(block_ind), function(nam) {
      new_items[new_items[, nam] == 1, ]
    })
  }

  new_items
}
