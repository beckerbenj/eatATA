
comb_itemIDs_nItems <- function(itemIDs, nItems = NULL) {
  if(!is.null(nItems) && (!is.numeric(nItems) || length(nItems) != 1)) stop("'nItems' needs to be a numeric vector of length 1.")

  if(is.null(itemIDs) && is.null(nItems)) stop("Both arguments 'itemIDs' and 'nItems' are missing. Specify one of them.")
  if(!is.null(itemIDs) && !is.null(nItems) && length(itemIDs) != nItems) stop("'itemIDs' and 'nItems' imply different item numbers.")
  check_itemIDs(itemIDs)

  if(is.null(nItems)) nItems <- length(itemIDs)
  nItems
}

check_itemIDs <- function(itemIDs) {
  if(!is.null(itemIDs) && (!is.character(itemIDs) && !is.numeric(itemIDs))) stop("'itemIDs' needs to be a vector.")
  if(is.null(itemIDs)) warning("Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.")
  if(any(duplicated(itemIDs))) stop("There are duplicate values in 'itemIDs'.")
  return()
}

check_single_numeric <- function(x, argument_name){
  if(!is.numeric(x) || length(x) != 1) {
    stop("'", argument_name, "' needs to be a numeric vector of length 1.")
  }
}
