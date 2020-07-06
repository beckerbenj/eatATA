
####
#############################################################################
#' Create item exclusion tuples from Item DB output.
#'
#' tbd
#'
#'@param items \code{data.frame} as exported by \code{Item DB}.
#'@param idCol Name of the item ID column.
#'@param exclusions Name of the exclusion column.
#'
#'@return A sparse matrix.
#'
#'@examples
#' #tbd
#'
#'@export
itemExclusionTuples <- function(items, idCol = "ID", exclusions) {
  # count maximum number of exclusion per item
  max_excl <- max(stringr::str_count(items[, exclusions], pattern = ","), na.rm = TRUE) + 1

  ## transform exclusions into tuples
  items2 <- tidyr::separate(items, col = exclusions, into = paste("excl_", 1:max_excl))

  excl_df <- items2[, c(idCol, paste("excl_", 1:max_excl))]


  out_list <- apply(excl_df, 1, function(excl_row) {
    do.call(rbind, lapply(excl_row[c(FALSE, !is.na(excl_row[2:max_excl+1]))], function(x) {
      sort(c(excl_row["ID"], x))
    }))
  })

  out_excl_df <- do.call(rbind, out_list)
  rownames(out_excl_df) <- NULL
  unique(out_excl_df)
}
