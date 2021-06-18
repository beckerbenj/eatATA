# Function to check check whether nItems, itemValues and itemIDs are compatible
check_nItems_itemValues_itemIDs <- function(nItems = NULL,
                                            itemIDs = NULL,
                                            itemValues = NULL) {


  # if not NULL, itemValues and itemIDs should be of same length
  if(!is.null(itemValues)){
    nItemValues <- length(itemValues)
    if(is.null(nItems)) nItems <- nItemValues
    if(nItemValues != nItems)
      stop("The length of 'itemValues' and 'nItems' should correspond.")
    if(!is.null(itemIDs)){
      nItemIDs <- length(itemIDs)
      if(nItemValues != nItemIDs)
        stop("The length of 'itemIDs' and 'itemValues' should correspond.")
    } else {
      warning("Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.")
      itemIDs <- sprintf(paste("it%0", nchar(nItems), "d", sep=''), seq_len(nItems))
    }
  } else {
    if(!is.null(itemIDs)){
    nItemIDs <- length(itemIDs)
    if(is.null(nItems)) nItems <- nItemIDs
    if(nItemIDs != nItems)
      stop("The length of 'itemIDs' and 'nItems' should correspond.")
    } else {
      if(is.null(nItems)) stop("Impossible to infer the number of items in the pool. Specify either 'itemIDs' or 'nItems' or 'itemValues'")
    }
  }

  # if not NULL, nItems should a numeric of lenght 1
  if(!is.null(nItems)) {
    check_type(nItems = nItems)
    check_length(nItems = nItems)
    if(is.null(itemIDs)){
      warning("Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.")
      itemIDs <- sprintf(paste("it%0", nchar(nItems), "d", sep=''), seq_len(nItems))
    }
  }

  if(!is.character(itemIDs) && !is.numeric(itemIDs)) stop("'itemIDs' needs to be a vector.")

  if(any(duplicated(itemIDs))) stop("There are duplicate values in 'itemIDs'.")

  if(is.null(itemValues)) itemValues <- rep(1, nItems)

  return(invisible(
    list(nItems = nItems,
         itemIDs = itemIDs,
         itemValues = itemValues)))

}


# Function to check whether the arguments are of the correct type
#' @importFrom methods formalArgs
check_type <- function(..., type = "numeric", stop = TRUE,
                       envir = parent.frame()) {

  # get arguments to test
  args <- as.list(match.call(expand.dots = TRUE))[-1]
  if(!is.null(names(args)))
    args <- args[!names(args) %in% formalArgs(check_type)]

  # get test
  test <- switch(type,
                 "numeric" = function(arg) is.integer(arg) || is.numeric(arg),
                 function(arg) typeof(arg) == type)

  # which are OK
  OK <- sapply(args, function(arg) {
    if(is.language(arg)) arg <- eval(arg, envir = envir)
    test(arg)
  })

  # error message
  if(any(!OK) & stop) stop(
    paste0("'",
           paste(names(args)[!OK], collapse = "', '"),
           "' should be a ", type, " vector."))
  return(invisible(OK))
}



# Function to check whether the arguments are of the correct length
check_length <- function(..., length = 1, stop = TRUE,
                         envir = parent.frame()) {


  # get arguments to test
  args <- as.list(match.call(expand.dots = TRUE))[-1]
  if(!is.null(names(args)))
    args <- args[!names(args) %in% formalArgs(check_length)]

  whichNoName <- which(names(args) == "")
  for(argIndex in whichNoName) {
    names(args)[whichNoName] <- as.character(args[whichNoName])
  }

  # which are OK
  OK <- sapply(args, function(arg) {
    if(is.language(arg)) arg <- eval(arg, envir = envir)
    length(arg)
  }) == length

  # error message
  if(any(!OK) & stop) stop(
    paste0("'",
           paste(names(args)[!OK], collapse = "', '"),
           "' should be a vector of length ", length, "."))
  return(invisible(OK))
}






# Function to check info_text
check_info_text <- function(info_text, itemValuesName, operator, targetValue){
  if(is.null(info_text)){
    info_text <- paste0(itemValuesName, operator, targetValue)
  }
  check_length(info_text = info_text)
  check_type(info_text = info_text, type = "character")
  return(info_text)
}



# Function to do multipe checks
do_checks_eatATA <- function(nItems,
                             itemIDs,
                             itemValues,
                             formValues = NULL,
                             operator,
                             nForms,
                             targetValue,
                             info_text,
                             itemValuesName,
                             whichItems,
                             testFormValues = FALSE,
                             envir = parent.frame()){
  item_info <- check_nItems_itemValues_itemIDs(nItems = nItems,
                                               itemIDs = itemIDs,
                                               itemValues = itemValues)
  check_length(nForms = nForms, targetValue = targetValue,
               envir = envir)
  if(testFormValues) check_length(formValues, length = nForms)
  operator <- match.arg(operator, c("<=", "=", ">="))
  info_text <- check_info_text(info_text, itemValuesName, operator, targetValue)
  whichItems <- whichItemsToNumeric(whichItems, item_info$itemIDs)
  return(list(nItems = item_info$nItems,
              itemIDs = item_info$itemIDs,
              itemValues = item_info$itemValues,
              operator = operator,
              info_text = info_text,
              whichItems = whichItems,
              formValues = formValues))
}


# Function to change whichItems into a numeric vector
whichItemsToNumeric <- function(whichItems, itemIDs) {
  if(is.null(whichItems)) return(seq_along(itemIDs))
  if(is.character(whichItems)) {
    if(is.null(itemIDs)) stop("item IDs supplied to 'whichItems' but not to 'itemIDs'.")
    not_in_itemIDs <- setdiff(whichItems, itemIDs)
    if(length(not_in_itemIDs) > 0) stop("The following item IDs are in 'whichItem' but not in 'itemIDs': ",
                                        paste(not_in_itemIDs, collapse = ", "))
    return(match(whichItems, itemIDs))
  }
  if(max(whichItems) > length(itemIDs)) stop("Some values in 'whichItems' are out of range. That is, higher than the length of 'itemIDs'.")
  whichItems
}
