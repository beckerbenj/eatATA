#############################################################################
#' Analyze block exclusiveness
#'
#' Use exclusion tuples information to determine which assembled test blocks are exclusive.
#'
#' If exclusion tuples have been used to assemble test forms (using the \code{\link{itemExclusionConstraint}}
#' function), the resulting
#' item blocks might also be exclusive. Using the initially used item exclusion tuples and the optimal solution
#' given by \code{useSolver} this function determines, which item blocks are exclusive and can not be together in an
#' assembled test form.
#'
#'@param solverOut Object created by \code{useSolver}.
#'@param items Original \code{data.frame} containing information on item level.
#'@param idCol Column name with item IDs in the \code{items} \code{data.frames}.
#'@param exclusionTuples \code{data.frame} with two columns, containing tuples with item IDs which should be in test
#'forms exclusively. Must be the same object as used in \code{\link{itemExclusionConstraint}}.
#'
#'@return A \code{data.frame} of block exclusions.
#'
#'@examples
#' ## Full workflow using itemExclusionTuples
#' # Example data.frame
#' items <- data.frame(ID = c("items1", "items2", "items3", "items4"),
#'                      exclusions = c("items2, items3", NA, NA, NA),
#'                      stringsAsFactors = FALSE)
#'
#' # Create tuples
#' exTuples2 <- itemExclusionTuples(items = items, idCol = "ID", exclusions = "exclusions",
#'                     sepPattern = ", ")
#'
#' #' ## Create constraints
#' exclusion_constraint <- itemExclusionConstraint(nForms = 2, exclusionTuples = exTuples2,
#'                                                 itemIDs = items$ID)
#' depletion_constraint <- depletePoolConstraint(2, nItems = 4)
#' target_constraint <- itemTargetConstraint(nForms = 2, nItems = 4,
#'                                           itemValues = c(3, 1.5, 2, 4), targetValue = 1)
#'
#' opt_solution <- useSolver(list(exclusion_constraint, target_constraint,
#'                                         depletion_constraint),
#'                                    nForms = 2, nItems = 4, itemIDs = items$ID)
#'
#' analyzeBlockExclusion(opt_solution, items = items, idCol = "ID",
#'                        exclusionTuples = exTuples2)
#'
#'
#'@export
analyzeBlockExclusion <- function(solverOut, items, idCol, exclusionTuples){
  if(!is.data.frame(items)) stop("'items' must be a data.frame.")
  if(!idCol %in% names(items)) stop("'idCol' must be a column name in 'items'.")
  if(!(is.data.frame(exclusionTuples) || is.matrix(exclusionTuples))) stop("'exclusionTuples' must be a data.frame or matrix.")
  if(!ncol(exclusionTuples) == 2) stop("'exclusionTuples' must have two columns.")
  check_solverOut(solverOut)

  processedObj <- inspectSolution(solverOut, items, idCol = idCol, colNames = names(items), colSums = FALSE)

  #names(processedObj) <- paste0("block ", seq(length(processedObj)))
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


do_call_rbind_withName <- function (label_list, name = names(label_list), colName)
{
  label_list <- Map(function(df, name) {
    if (is.null(df))
      return(df)
    data.frame(df, placeHolder = rep(name, nrow(df)), stringsAsFactors = FALSE)
  }, df = label_list, name = name)
  label_df <- do.call(rbind, label_list)
  rownames(label_df) <- NULL
  names(label_df)[ncol(label_df)] <- colName
  label_df
}
