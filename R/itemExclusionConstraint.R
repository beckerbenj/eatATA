
####
#############################################################################
#' Create item inclusion or exclusion constraints.
#'
#' Create constraints that prohibit that item pairs occur in the same test forms (exclusions) or
#' force item pairs to be in the same test forms (inclusions).
#'
#' Item tuples can, for example, be created by the function \code{\link{itemTuples}}.
#'
#'@inheritParams itemValuesConstraint
#'@param itemTuples \code{data.frame} with two columns, containing tuples with item IDs which should be in test forms inclusively or exclusively.
#'@param itemIDs Character vector of item IDs in correct ordering.
#'
#'@return An object of class \code{"constraint"}.
#'
#'@examples
#' ## Simple Exclusion Example
#' # item-IDs
#' IDs <- c("item1", "item2", "item3", "item4")
#'
#' # exclusion tuples: Item 1 can not be in the test form as item 2 and 3
#' exTuples <- data.frame(v1 = c("item1", "item1"), v2 = c("item2", "item3"),
#'                        stringsAsFactors = FALSE)
#' # inclusion tuples: Items 2 and 3 have to be in the same test form
#' inTuples <- data.frame(v1 = c("item2"), v2 = c("item3"),
#'                        stringsAsFactors = FALSE)
#'
#' # create constraints
#' itemExclusionConstraint(nForms = 2, itemTuples = exTuples, itemIDs = IDs)
#' itemInclusionConstraint(nForms = 2, itemTuples = inTuples, itemIDs = IDs)
#'
#'
#' ########
#' ## Full workflow for exclusions using itemTuples
#' # Example data.frame
#' items <- data.frame(ID = c("item1", "item2", "item3", "item4"),
#'                      infoCol = c("item2, item3", NA, NA, NA))
#'
#' # Create tuples
#' exTuples2 <- itemTuples(items = items, idCol = "ID", infoCol = "infoCol",
#'                     sepPattern = ", ")
#'
#' ## Create constraints
#' itemExclusionConstraint(nForms = 2, itemTuples = exTuples2, itemIDs = IDs)
#'
#' @describeIn itemExclusionConstraint item pair exclusion constraints
#'@export
itemExclusionConstraint <- function(nForms, itemTuples, itemIDs,
                                    whichForms = seq_len(nForms),
                                    info_text = NULL) {
  check_item_identifiers(new_idents = unique(unlist(itemTuples)), ident_col = itemIDs)

  itemTuples <- itemTuples[itemTuples[, 1] %in% itemIDs, ]
  itemTuples <- itemTuples[itemTuples[, 2] %in% itemIDs, ]

  nItems <- length(itemIDs)
  id_df <- data.frame(no = seq(nItems), ID = itemIDs)

  ## tuples into constraints
  constr_list <- apply(itemTuples, 1, function(exclusion_row) {
    itemValues <- structure(rep(0, nItems), names = itemIDs)
    itemValues[which(itemIDs %in% exclusion_row)] <- 1

    itemValuesConstraint(nForms, itemValues, targetValue = 1,
                         info_text = paste0(exclusion_row, collapse = "_excludes_"))
  })
  combineConstraints(constr_list, message = FALSE)
}



#' @describeIn itemExclusionConstraint item pair inclusion constraints
#' @export
itemInclusionConstraint <- function(nForms, itemTuples, itemIDs,
                                    whichForms = seq_len(nForms),
                                    info_text = NULL) {
  check_item_identifiers(new_idents = unique(unlist(itemTuples)), ident_col = itemIDs)

  itemTuples <- itemTuples[itemTuples[, 1] %in% itemIDs, ]
  itemTuples <- itemTuples[itemTuples[, 2] %in% itemIDs, ]

  nItems <- length(itemIDs)
  id_df <- data.frame(no = seq(nItems), ID = itemIDs)

  ## tuples into constraints
  constr_list <- apply(itemTuples, 1, function(inclusion_row) {
    itemValues <- structure(rep(0, nItems), names = itemIDs)
    itemValues[which(itemIDs %in% inclusion_row)] <- c(1, -1)

    itemValuesConstraint(nForms, itemValues, targetValue = 0, operator = "=",
                         info_text = paste0(inclusion_row, collapse = "_includes_"))
  })
  combineConstraints(constr_list, message = FALSE)
}



