
####
#############################################################################
#' Create item exclusion constraints.
#'
#' Create constraints that prohibit that item pairs occur in the same test forms.
#'
#' Item exclusion pairs can, for example, be created by the function \code{\link{itemExclusionTuples}}.
#'
#'@inheritParams itemValuesConstraint
#'@param exclusionTuples \code{data.frame} with two columns, containing tuples with item IDs which should be in test forms exclusively.
#'@param itemIDs Character vector of item IDs in correct ordering.
#'
#'@return An object of class \code{"constraint"}.
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
itemExclusionConstraint <- function(nForms, exclusionTuples, itemIDs,
                                    whichForms = seq_len(nForms),
                                    info_text = NULL) {
  check_item_identifiers(new_idents = unique(unlist(exclusionTuples)), ident_col = itemIDs)

  exclusionTuples <- exclusionTuples[exclusionTuples[, 1] %in% itemIDs, ]
  exclusionTuples <- exclusionTuples[exclusionTuples[, 2] %in% itemIDs, ]

  nItems <- length(itemIDs)
  id_df <- data.frame(no = seq(nItems), ID = itemIDs)

  ## tuples into constraints
  constr_list <- apply(exclusionTuples, 1, function(exclusion_row) {
    itemValues <- structure(rep(0, nItems), names = itemIDs)
    itemValues[which(itemIDs %in% exclusion_row)] <- 1

    itemValuesConstraint(nForms, itemValues, targetValue = 1,
                         info_text = paste0(exclusion_row, collapse = "_excludes_"))
  })
  combineConstraints(constr_list, message = FALSE)
}



#' Create item exclusion tuples.
#'
#' If item exclusions are stored as a character vector, \code{itemExclusionTuples} separates this vector and creates item pairs ('tuples').
#'
#' Exclusion tuples can be used by \code{\link{itemExclusionConstraint}} to set up exclusion constraints. Note that a
#' separator pattern has to be used consistently throughout the column (e.g. \code{", "}).
#'
#'@param items A \code{data.frame} with information on an item pool.
#'@param idCol character or integer indicating the item ID column in \code{items}.
#'@param exclusions character or integer indicating the item ID column in \code{items}.
#'@param sepPattern String which should be used for separating item IDs in the \code{exclusions} column..
#'
#'@return A \code{data.frame} with two columns.
#'
#'@examples
#' # Example data.frame
#' items <- data.frame(ID = c("item1", "item2", "item3", "item4"),
#'                      exclusions = c("item2, item3", NA, NA, NA))
#'
#' # Create tuples
#' itemExclusionTuples(items = items, idCol = "ID", exclusions = 2,
#'                     sepPattern = ", ")
#'
#'
#'@export
itemExclusionTuples <- function(items, idCol = "ID", exclusions, sepPattern = ", ") {
  # count maximum number of exclusion per item
  #max_excl <- max(stringr::str_count(items[, exclusions], pattern = sepPattern), na.rm = TRUE) + 1
  splitted_vec <- strsplit(as.character(items[[exclusions]]), split = sepPattern)
  max_excl <- max(sapply(splitted_vec, length))

  splitted_list <- lapply(splitted_vec, function(x) {
    diff_na <- max_excl - length(x)
    out <- c(x, rep(NA, diff_na))
    #if(all(is.na(out))) NULL
    out
  })
  #if(nrow(items) == 80) browser()

  ## transform exclusions into tuples
  #items2 <- tidyr::separate(items, col = exclusions, into = paste("excl_", 1:max_excl), sep = sepPattern)
  #excl_df <- items2[, c(idCol, paste("excl_", 1:max_excl))]
  excl_vars <- do.call(rbind, splitted_list)
  excl_df <- data.frame(items[idCol], excl_vars, stringsAsFactors = FALSE)
  colnames(excl_df)[-1] <- c(paste0("excl_", 1:max_excl))

  out_list <- apply(excl_df, 1, function(excl_row) {
    do.call(rbind, lapply(excl_row[c(FALSE, !is.na(excl_row[2:(max_excl+1)]))], function(x) {
      sort(as.character(c(excl_row[idCol], x)))
    }))
  })

  out_excl_df <- do.call(rbind, out_list)
  rownames(out_excl_df) <- NULL
  out_excl_df2 <- unique(out_excl_df)

  #browser()
  apply(out_excl_df2, 1, function(excl_row) {
    if(excl_row[1] == excl_row[2]) stop("The following item is excluded from being with itself: ", excl_row[1])
  })
  check_item_identifiers(new_idents = unique(unlist(out_excl_df2)), ident_col = items[, idCol])

  out_excl_df2
}

# test for invalid item identifiers
check_item_identifiers <- function(new_idents, ident_col) {
  idents_not_in_idents <- new_idents[!new_idents %in% ident_col]
  idents_not_in_idents_string <- paste(idents_not_in_idents, collapse = "', '")
  if(length(idents_not_in_idents) > 0) warning("The following item identifiers in the exclusion column are not item identifiers in the idCol column (check for correct sepPattern!): ", paste0("'", idents_not_in_idents_string, "'"))
  return()
}
