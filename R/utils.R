# unexported utility functions

#### function that creates the A-matrix for binary decision variables - for form constraints ####
get_A_binary_forms <- function(nForms, nItems,
                               itemValues,
                               whichForms = seq_len(nForms)){

  # number of used forms
  nUsedForms = length(whichForms)

  # number of binary decision variables
  nBin <- nForms* nItems

  # column indexes for binary decision variables
  jIndex <- do.call(c, lapply(whichForms, function(formNr) {
    (formNr - 1) * nItems + 1:nItems
  }))

  A_binary = Matrix::sparseMatrix(
    i = rep(1:nUsedForms, each = nItems),
    j = jIndex,
    x = rep(itemValues, times = nUsedForms),
    dims = c(nUsedForms, nBin))
  A_binary
}


#### function that creates the A-matrix for binary decision variables - for item constraints ####
get_A_binary_items <- function(nForms, nItems,
                               formValues,
                               whichItems = seq_len(nItems)){

  # number of  used items
  nUsedItems <- length(whichItems)

  # number of binary decision variables
  nBin <- nForms * nItems

  # row indexes for binary decision variables
  jIndex <- do.call(c, lapply(whichItems, function(itemNr) {
    itemNr + (seq_len(nForms) - 1) * nItems
  }))

  A_binary = Matrix::sparseMatrix(
    i = rep(1:nUsedItems, each = nForms),
    j = jIndex,
    x = rep(formValues, times = nUsedItems),
    dims = c(nUsedItems, nBin))
  A_binary
}


#### function that creates the A-matrix for binary decision variables - for item*forms constraints ####
get_A_binary_items_forms <- function(nForms, nItems,
                               values,
                               whichForms = seq_len(nForms),
                               whichItems = seq_len(nItems)){

  # number of  used items
  nUsedItems <- length(whichItems)

  # number of used forms
  nUsedForms = length(whichForms)

  # length of values should be equal to nUsedItems * nUsedItems
  nValues <- nUsedForms * nUsedItems
  if(length(values) != nValues) stop("The number of values does not correspond to whichForms and whichItems.")

  # number of binary decision variables
  nBin <- nForms * nItems

  # row indexes for binary decision variables
  jIndex <- do.call(c, lapply(whichForms, function(formNr) {
    whichItems + (formNr - 1) * nItems
  }))

  A_binary = Matrix::sparseMatrix(
    i = rep(1, nValues),
    j = jIndex,
    x = values,
    dims = c(1, nBin))
  A_binary
}




#### function that makes data.frame with row-wise information about the constraints ####
make_info <- function(info_text, whichForms = NULL, whichItems = NULL){
  if(is.null(whichForms)){
    if(is.null(whichItems)) stop("'whichForms' and 'whichItems' should not be both NULL.")
    out <- data.frame(rowNr = seq_along(whichItems),
                      formNr = NA,
                      itemNr = whichItems,
                      constraint = info_text,
                      stringsAsFactors = FALSE)
  } else if(is.null(whichItems)){
    out <- data.frame(rowNr = seq_along(whichForms),
                      formNr = whichForms,
                      itemNr = NA,
                      constraint = info_text,
                      stringsAsFactors = FALSE)
  } else
    out <- data.frame(rowNr = 1,
                      formNr = NA,
                      itemNr = NA,
                      constraint = info_text,
                      stringsAsFactors = FALSE)
  return(out)
}


#### function that creates an S3 class 'constraint' ####
newConstraint <- function(A_binary, A_real = NULL, operators, d,
                          nForms, nItems, sense = NULL,
                          c_binary = NULL, c_real = NULL, info, itemIDs = NULL){

  ### check input
  # check if A_binary is a Matrix
  stopifnot(inherits(A_binary, "Matrix"))

  # check if operators, d, and info correspond with A_binary
  nRow <- dim(A_binary)[1]
  stopifnot(all(c(length(operators), length(d), dim(info)[1]) == nRow))

  # check if A_binary corresponds with nForms and nItems
  nBin <- nForms * nItems
  stopifnot(dim(A_binary)[2] == nBin)

  # check c_binary
  if(!is.null(c_binary)) stopifnot(length(c_binary) == nBin)

  # check dims of A_real
  if(is.null(A_real)) {
    stopifnot(is.null(c_real))
  } else {
    stopifnot(dim(A_real)[1] == nRow)
    if(is.null(c_real))
    {
      if(dim(A_real)[2] == 1) {
        c_real <- 1
      } else stop("Check 'A_real' and 'c_real'.")
    }
    stopifnot(dim(A_real)[2] == length(c_real))
  }



  # check sense
  if(!is.null(sense)) sense <- match.arg(sense, choices = c("min", "max"))

  # check opertors
  stopifnot(operators %in% c("<=", "=", ">="))

  out <- list(A_binary = A_binary,
              A_real = A_real,
              operators = operators,
              d = d,
              c_binary = c_binary,
              c_real = c_real)

  # create itemIDs if not available
  if(is.null(itemIDs)) {
    # message("Default item IDs were created. Inspect the constraint-object to view the item IDs.")
    itemIDs <- sprintf(paste("it%0", nchar(nItems), "d", sep=''), seq_len(nItems))
  }

  # check length of itemIDs
  if(length(itemIDs) != nItems) stop("The number of 'itemIDs' does not correspond to 'nItems'")

  structure(out,
            class = "constraint",
            nForms = nForms,
            nItems = nItems,
            sense = sense,
            info = info,
            itemIDs = itemIDs)
}



#### function that creates constraints per form - general ####
makeFormConstraint <- function(nForms, itemValues, realVar, operator,
                               targetValue, whichForms, sense, c_binary = NULL,
                               c_real = NULL, info_text = NULL, itemIDs = NULL){

  # whichForms should be a subset of 1:nForms
  if(! all(whichForms %in% seq_len(nForms))) stop("'whichForms' should be a subset of all the possible test form numbers given 'nForms'.")

  # number of items
  nItems <- length(itemValues)

  # number of used forms in constraints
  nUsedForms <- length(whichForms)

  # A matrix with weights - only for binary variables
  A_binary <- get_A_binary_forms(nForms, nItems, itemValues, whichForms)

  # A matrix with weights - only for real variables
  A_real <- 'if'(is.null(realVar), realVar, matrix(rep(realVar, each = nUsedForms), nrow = nUsedForms))

  # vector with operators
  operators <- rep(operator, nUsedForms)

  # rhs d vector with target values
  d <- rep(targetValue, nUsedForms)

  # data.frame with information about the constraint
  info <- make_info('if'(is.null(info_text),
                         deparse(substitute(itemValues)),
                         info_text), whichForms = whichForms)

  # make constraint object
  newConstraint(A_binary, A_real, operators, d,
                nForms, nItems, sense, c_binary, c_real, info,
                itemIDs = itemIDs)

}


#### function that creates constraints per item - general ####
makeItemConstraint <- function(nForms, nItems, formValues, realVar, operator,
                               targetValue, whichItems, sense, c_binary = NULL,
                               c_real = NULL, info_text = NULL, itemIDs = NULL){


  if(!is.null(itemIDs) & is.character(whichItems)) {
    if(!all(whichItems %in% itemIDs))
      stop("The itemIDs in 'whichItems' do not correspond with the 'itemIDs'.")
       whichItems <- which(itemIDs %in% whichItems)
  }

  # whichItems should be a subset of 1:nItems
  if(! all(whichItems %in% seq_len(nItems))) stop("'whichItems' should be a subset of either all the possible items numbers given 'nItems', or of the 'itemIDs'.")


  # number of used forms in constraints
  nUsedItems <- length(whichItems)

  # A matrix with weights - only for binary variables
  A_binary <- get_A_binary_items(nForms, nItems, formValues, whichItems)

  # A matrix with weights - only for real variables
  A_real <- 'if'(is.null(realVar), realVar, matrix(rep(realVar, each = nUsedItems), nrow = nUsedItems))

  # vector with operators
  operators <- rep(operator, nUsedItems)

  # rhs d vector with target values
  d <- rep(targetValue, nUsedItems)

  # data.frame with information about the constraint
  info <- make_info('if'(is.null(info_text),
                         deparse(substitute(formValues)),
                         info_text), whichItems = whichItems)

  # make constraint object
  newConstraint(A_binary, A_real, operators, d,
                nForms, nItems, sense, c_binary, c_real, info,
                itemIDs = itemIDs)

}



#### function that creates constraints across items and forms - general ####
makeItemFormConstraint <- function(nForms, nItems, values, realVar, operator,
                               targetValue, whichForms, whichItems, sense,
                               c_binary = NULL,
                               c_real = NULL, info_text = NULL, itemIDs = NULL){


  if(!is.null(itemIDs) & is.character(whichItems)) {
    if(!all(whichItems %in% itemIDs))
      stop("The itemIDs in 'whichItems' do not correspond with the 'itemIDs'.")
    whichItems <- which(itemIDs %in% whichItems)
  }

  # whichForms should be a subset of 1:nForms
  if(! all(whichForms %in% seq_len(nForms))) stop("'whichForms' should be a subset of all the possible test form numbers given 'nForms'.")

  # whichItems should be a subset of 1:nItems
  if(! all(whichItems %in% seq_len(nItems))) stop("'whichItems' should be a subset of either all the possible items numbers given 'nItems', or of the 'itemIDs'.")

  # number of used forms in constraints
  nUsedForms <- length(whichForms)

  # number of used forms in constraints
  nUsedItems <- length(whichItems)

  # A matrix with weights - only for binary variables
  A_binary <- get_A_binary_items_forms(nForms, nItems, values, whichForms, whichItems)

  # A matrix with weights - only for real variables
  A_real <- 'if'(is.null(realVar), realVar, matrix(realVar))

  # data.frame with information about the constraint
  info <- make_info('if'(is.null(info_text),
                         paste0(
                           paste0("formsNrs:", paste(whichForms, collapse = "-")),
                           paste0(" + itemsNrs:", paste(whichItems, collapse = "-")),
                           paste0(" = ", targetValue)),
                         info_text),
                    whichForms = whichForms,
                    whichItems = whichItems)

  # make constraint object
  newConstraint(A_binary, A_real, operator, targetValue,
                nForms, nItems, sense, c_binary, c_real, info,
                itemIDs = itemIDs)

}



#### function to combine two constraints ####
combine2Constraints <- function(x, y){

  # check if both x and y are of class constraint
  if(!all(inherits(x, "constraint"), inherits(y, "constraint"))) stop("Both arguments should be of class 'constraint'")


  # check if nForms and nItems are the same
  if(attr(x, "nForms") != attr(y, "nForms")) stop("The constraints cannot be combined, the number of forms differs.")
  if(attr(x, "nItems") != attr(y, "nItems")) stop("The constraints cannot be combined, the number of items in the pool differs.")

  # check if itemIDs are the same
  if(!all(attr(x, "itemIDs") == attr(y, "itemIDs"))) stop("The constraints cannot be combined, the itemIDs differ.")


  # check c_real and adjust c_real and A_real where necessary
  if(is.null(x$c_real) & !is.null(y$c_real)){
    c_real <- y$c_real
    x$A_real <- matrix(0, nrow = dim(x$A_binary)[1], ncol = length(c_real))
  } else if(is.null(y$c_real) & !is.null(x$c_real)){
    c_real <- x$c_real
    y$A_real <- matrix(0, nrow = dim(y$A_binary)[1], ncol = length(c_real))
  } else if(!is.null(x$c_real) & !is.null(y$c_real)){
    n_c_x <- length(x$c_real)
    n_c_y <- length(y$c_real)
    if(n_c_x == n_c_y) {
      if(!all(x$c_real == y$c_real)) stop("The weights of the real variables in the objective function ('c_real') differ.")
      c_real <- x$c_real
    } else if(n_c_x > n_c_y){
      if(!all(x$c_real[n_c_y] == y$c_real)) stop("The weights of the real variables in the objective function ('c_real') differ.")
      c_real <- x$c_real
      y$A_real <- cbind(y$A_real, matrix(0, nrow = nrow(y$A_real), ncol = (n_c_x - n_c_y)))
    } else if(n_c_y > n_c_x){
      if(!all(x$c_real == y$c_real[n_c_x])) stop("The weights of the real variables in the objective function ('c_real') differ.")
      c_real <- y$c_real
      x$A_real <- cbind(x$A_real, matrix(0, nrow = nrow(x$A_real), ncol = (n_c_y - n_c_x)))
    }
  } else c_real <- NULL


  # check c_binary and adjust c_binary
  if(is.null(x$c_binary) & !is.null(y$c_binary)){
    c_binary <- y$c_binary
  } else if(is.null(y$c_binary) & !is.null(x$c_binary)){
    c_binary <- x$c_binary
  } else if(!is.null(x$c_binary) & !is.null(y$c_binary)){
    if(x$c_binary != y$c_binary){
      stop("The weights of the binary variables in the objective function ('c_binary') differ.")
    } else c_binary <- x$c_binary
  } else c_binary <- NULL


  # check if sense of constraints corresponds
  if (is.null(attr(x, "sense")) & is.null(attr(y, "sense"))) sense <- NULL
  else if (is.null(attr(x, "sense")) & !is.null(attr(y, "sense"))) sense <- attr(y, "sense")
  else if (!is.null(attr(x, "sense")) & is.null(attr(y, "sense"))) sense <- attr(x, "sense")
  else if (is.null(attr(x, "sense")) == is.null(attr(y, "sense"))) sense <- attr(x, "sense")
  else stop("The constraints cannot be combined: the 'sense' of the objective function differs.")


  # combine info
  attr(y, "info")$rowNr <- attr(y, "info")$rowNr + max(attr(x, "info")$rowNr)
  info <- rbind(attr(x, "info"), attr(y, "info"))

  newConstraint(A_binary = rbind(x$A_binary, y$A_binary),
                A_real = rbind(x$A_real, y$A_real),
                operators = c(x$operators, y$operators),
                d = c(x$d, y$d),
                c_binary = c_binary,
                c_real = c_real,
                nForms = attr(x, "nForms"),
                nItems = attr(x, "nItems"),
                sense = sense,
                info = info,
                itemIDs = attr(x, "itemIDs"))
}
