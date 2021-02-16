####
#############################################################################
#' Create item inclusion tuples from item stem.
#'
#' If item-stimulus hierarchies are stored in a single stimulus column,
#' \code{stemInclusionTuples} transforms this format into item pairs ('tuples').
#'
#' Inclusion tuples can be used by \code{\link{itemInclusionConstraint}} to set up inclusion constraints.
#'
#'@inheritParams itemTuples
#'@param stemCol A column in \code{items} containing the item stems or stimulus names, shared among items which should be in the same test form.
#'
#'@return A \code{data.frame} with two columns.
#'
#'@examples
#' # Example data.frame
#' inclDF <- data.frame(ID = paste0("item_", 1:6),
#'           stem = c(rep("stim_1", 3), "stim_3", "stim_4", "stim_3"),
#'           stringsAsFactors = FALSE)
#'
#' # Create tuples
#' stemInclusionTuples(inclDF, idCol = "ID", stemCol = "stem")
#'
#'
#'@export
stemInclusionTuples <- function(items, idCol = "ID", stemCol) {
  if(is.character(idCol) && !idCol %in% names(items)) stop("'idCol' is not a column in 'items'.")
  if(is.character(stemCol) && !stemCol %in% names(items)) stop("'stemCol' is not a column in 'items'.")

  incl_str <- data.frame(ID = items[, idCol], incl = NA, stringsAsFactors = FALSE)
  for(ro in seq(nrow(items))) {
    stem <- items[ro, stemCol]
    same_stem <- items[items[, stemCol] == stem, idCol]
    same_stem <- setdiff(same_stem, items[ro, idCol])
    if(length(same_stem) > 0) incl_str[ro, "incl"] <- paste(same_stem, collapse = ",")
  }

  itemTuples(items = incl_str, idCol = "ID", infoCol = "incl", sepPattern = ",")
}
