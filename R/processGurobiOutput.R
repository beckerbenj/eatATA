#############################################################################
#' Process gurobi output for readability.
#'
#' tbd
#'
#'@param gurobiObj Object created by \code{Gurobi} solver.
#'@param items Original \code{data.frame} containing information on item level.
#'@param nForms Number of forms to be created.
#'@param nItems Number of items in the item pool.
#'@param output Should the output be returned as a \code{data.frame} or a \code{list}.
#'
#'@return a \code{data.frame} or a \code{list}.
#'
#'@examples
#' #tbd
#'
#'@export
processGurobiOutput <- function(gurobiObj, items, nForms, nItems, output = "data.frame"){
  block_ind <- 1:nForms
  names(block_ind) <- paste("Block", block_ind, sep = "_")
  block_df <- as.data.frame(lapply(block_ind, function(x) {
    ind <- (x-1)*80 + 1:80
    gurobiObj$x[ind]
  }))

  new_items <- cbind(items, block_df)

  if(output == "list") {
    new_items <- lapply(names(block_ind), function(nam) {
      df <- new_items[new_items[, nam] == 1, ]
      list(df, c(time = sum(df[, 2]), Aufgaben = nrow(df)))
    })
  }

  new_items
}
