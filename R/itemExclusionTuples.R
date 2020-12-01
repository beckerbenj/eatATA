
####
#############################################################################
#' Create item exclusion tuples.
#'
#' If item exclusions are stored as a character vector, \code{itemExclusionTuples} separates this vector and creates item pairs ('tuples').
#'
#' Exclusion tuples can be used by \code{\link{itemExclusionConstraint}} to set up exclusion constraints. Note that a
#' separator pattern has to be used consistently throughout the column (e.g. \code{", "}).
#'
#'@param items A \code{data.frame} with information on an item pool.
#'@param idCol Name of the item ID column.
#'@param exclusions Name of the exclusion column.
#'@param sepPattern String which should be used for separating item IDs in the \code{exclusions} column..
#'
#'@return A \code{data.frame} with two columns.
#'
#'@examples
#' # Example data.frame
#' items <- data.frame(ID = c("items1", "items2", "items3", "items4"),
#'                      exclusions = c("items2, items3", NA, NA, NA))
#'
#' # Create tuples
#' itemExclusionTuples(items = items, idCol = "ID", exclusions = "exclusions",
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
  excl_df <- data.frame(items[, idCol], excl_vars, stringsAsFactors = FALSE)
  colnames(excl_df) <- c(idCol, paste0("excl_", 1:max_excl))

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
