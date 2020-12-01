#############################################################################
#' Analyze complex block exclusiveness
#'
#' Use exclusion tuples information from independent test assembly problems to determine which assembled
#' test blocks are exclusive.
#'
#' If exclusion tuples have been used to assemble test forms (using the \code{\link{itemExclusionConstraint}}
#' function), the resulting
#' item blocks might also be exclusive. Using the initially used item exclusion tuples and the optimal solution
#' given by \code{useSolver} this function determines, which item blocks are exclusive and can not be together in an
#' assembled test form. \code{analyzeComplexBlockExclusion} allows analyzing block exclusiveness from separate test
#' assembly problems. This can be useful if test forms consist of blocks containing different domains or dimensions.
#'
#'@param solverOut_list List of objects created by \code{useSolver}.
#'@param items_list List of original \code{data.frame} containing information on item level.
#'@param idCol Column name with item IDs in the \code{items} \code{data.frames}.
#'@param exclusionTuples_list List of \code{data.frames} with two columns, containing tuples with item IDs which
#'should be in test forms exclusively. Must be the same objects as used in \code{\link{itemExclusionConstraint}}.
#'
#'@return A \code{data.frame} of block exclusions.
#'
#'@examples
#' ## Full workflow using itemExclusionTuples
#' # tbd
#'
#'
#'@export
analyzeComplexBlockExclusion <- function(solverOut_list, items_list, idCol, exclusionTuples_list){
  ## to do: implement input checks
  #browser()

  ### restructure all in one big object
  processedObj <- Map(function(solverOut, items){
    inspectSolution(solverOut, items, idCol = idCol, colNames = names(items_list[[1]]), colSums = FALSE)
  }, solverOut = solverOut_list, items = items_list)
  processedObj <- unlist(processedObj, recursive = FALSE)
  names(processedObj) <- paste0("block_", seq(length(processedObj)))

  items <- do.call(rbind, items_list)
  exclusionTuples <- do.call(rbind, exclusionTuples_list)

  match_df <- do_call_rbind_withName(processedObj, colName = "block")[, c(idCol, "block")]
  #if(!all(unlist(exclusionTuples) %in% match_df[, idCol])) browser()

  exclusionTuples <- exclusionTuples[exclusionTuples[, 1] %in% match_df[, idCol], ]
  exclusionTuples <- exclusionTuples[exclusionTuples[, 2] %in% match_df[, idCol], ]

  exclusionOut <- exclusionTuples
  exclusionOut[, 1] <- match_df$block[match(exclusionOut[, 1], match_df[, idCol])]
  exclusionOut[, 2] <- match_df$block[match(exclusionOut[, 2], match_df[, idCol])]

  out <- do.call(rbind, lapply(seq(nrow(exclusionOut)), function(row_no) {
    sorted_vec <- sort(as.character(exclusionOut[row_no, ]))
    as.character(sorted_vec)
  }))
  colnames(out) <- c("Name 1", "Name 2")
  unique(as.data.frame(out, stringsAsFactors = FALSE))
}
