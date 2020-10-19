
####
#############################################################################
#' Create item exclusion constraints.
#'
#' Create constraints that prohibit that item pairs occur in the same test forms.
#'
#' Item exclusion pairs can, for example, be created by the function \code{\link{itemExclusionTuples}}.
#'
#'@param nForms Number of forms to be created.
#'@param exclusionTuples \code{data.frame} with two columns, containing tuples with item IDs which should be in test forms exclusively.
#'@param itemIDs Character vector of item IDs in correct ordering.
#'
#'@return A sparse matrix.
#'
#'@examples
#' ## item-IDs
#' IDs <- c("item1", "item2", "item3", "item4")
#'
#' ## tuples: Item 1 can not be in the test form as item 2 and 3
#' exTuples <- data.frame(v1 = c("item1", "item1"), v2 = c("item2", "item3"),
#'                        stringsAsFactors = FALSE)
#'
#' ## Create constraints
#' itemExclusionConstraint(nForms = 2, exclusionTuples = exTuples, itemIDs = IDs)
#'
#'
#' ########
#' ## Full workflow using itemExclusionTuples
#' # Example data.frame
#' items <- data.frame(ID = c("item1", "item2", "item3", "item4"),
#'                      exclusions = c("item2, item3", NA, NA, NA))
#'
#' # Create tuples
#' exTuples2 <- itemExclusionTuples(items = items, idCol = "ID", exclusions = "exclusions",
#'                     sepPattern = ", ")
#'
#' #' ## Create constraints
#' itemExclusionConstraint(nForms = 2, exclusionTuples = exTuples2, itemIDs = IDs)
#'
#'@export
itemExclusionConstraint <- function(nForms, exclusionTuples, itemIDs) {
  check_item_identifiers(new_idents = unique(unlist(exclusionTuples)), ident_col = itemIDs)

  exclusionTuples <- exclusionTuples[exclusionTuples[, 1] %in% itemIDs, ]
  exclusionTuples <- exclusionTuples[exclusionTuples[, 2] %in% itemIDs, ]


  id_df <- data.frame(no = seq(length(itemIDs)), ID = itemIDs)

  ## tuples into constraints
  constr_list <- apply(exclusionTuples, 1, function(exclusion_row) {
    #browser()
    no1 <- id_df[id_df$ID == exclusion_row[1], "no"]
    no2 <- id_df[id_df$ID == exclusion_row[2], "no"]

    value_vec <- rep(0, nrow(id_df))
    value_vec[c(no1, no2)] <- 1
    ExclusionConstraint(nForms = nForms, nItems = nrow(id_df), itemValues = value_vec)

  })
  do.call(rbind, constr_list)
}


ExclusionConstraint <- function(nForms = nForms, nItems, itemValues,
                                targetValues = 1, tolerance = 0) {
  M <- nForms*nItems
  rbind(
    Matrix::sparseMatrix(i = c(rep(1:nForms, each = nItems), 1:nForms, 1:nForms, 1:nForms),
                         j = c(1:M, rep(M+1, nForms), rep(M+2, nForms), rep(M+3, nForms)),
                         x = c(rep(itemValues, times = nForms), rep(0, nForms), rep(c(-1), each = nForms),
                               rep(targetValues + tolerance, nForms)))
  )
}
