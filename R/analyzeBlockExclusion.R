#############################################################################
#' Analyze block exclusiveness
#'
#' Use exclusion tuples information to determine which assembled test blocks are exclusive.
#'
#' If exclusion tuples have been used to assemble test forms (using the \code{\link{itemExclusionConstraint}} function), the resulting
#' item blocks might also be exclusive. Using the initially used item exclusion tuples and the processed \code{gurobi} output
#' (via \code{\link{processGurobiOutput}}) this function determines, which item blocks are exclusive and can not be together in an
#' assembled test form.
#'
#'@param processedObj Object created by \code{gurobi} solver and processed by \code{\link{processGurobiOutput}}.
#'Must be a \code{list}.
#'@param idCol Column name with item IDs in the \code{data.frames} in \code{processedObj}.
#'@param exclusionTuples \code{data.frame} with two columns, containing tuples with item IDs which should be in test forms exclusively.
#' Must be the same object as used in \code{\link{itemExclusionConstraint}}.
#'
#'@return A \code{data.frame} of block exclusions.
#'
#'@examples
#' ## Full workflow using itemExclusionTuples
#' # Example data.frame
#' items <- data.frame(ID = c("items1", "items2", "items3", "items4"),
#'                      exclusions = c("items2, items3", NA, NA, NA))
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
#' gurobi_model <- prepareConstraints(list(exclusion_constraint, target_constraint,
#'                                         depletion_constraint),
#'                                    nForms = 2, nItems = 4)
#'
#'\dontrun{
#' # Run gurobi (this can only be run with Gurobi and the gurobi package installed,
#' # for which a Gurobi license is required)
#' gurobi_out <- gurobi::gurobi(gurobi_model, params = list(TimeLimit = 30))
#'
#' processedObj <- processGurobiOutput(gurobi_out, items = items, nForms = 2, output = "list")
#'
#' analyzeBlockExclusion(processedObj, exTuples2)
#' }
#'
#'@export
analyzeBlockExclusion <- function(processedObj, idCol, exclusionTuples){
  if(is.data.frame(processedObj)) stop("'processedObj' has to be a list, not a data.frame.")
  if(!idCol %in% names(processedObj[[1]])) stop("'idCol' must be a column name in the entries of 'processedObj'.")

  names(processedObj) <- paste0("block ", seq(length(processedObj)))
  match_df <- do_call_rbind_withName(processedObj, colName = "block")[, c(idCol, "block")]
  if(!all(unlist(exclusionTuples) %in% match_df[, idCol])) stop("Currently analyzeBlockExclusion only works if item pool is depleted.")


  exclusionOut <- exclusionTuples
  exclusionOut[, 1] <- match_df$block[match(exclusionOut[, 1], match_df[, idCol])]
  exclusionOut[, 2] <- match_df$block[match(exclusionOut[, 2], match_df[, idCol])]

  out <- do.call(rbind, lapply(seq(nrow(exclusionOut)), function(row_no) {
    sorted_vec <- sort(exclusionOut[row_no, ])
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
