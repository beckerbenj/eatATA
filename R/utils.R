# unexported utility functions

#### function that creates the A-matrix for binary decision variables - for form constrainst ####
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


#### function that creates the A-matrix for binary decision variables - for item constrainst ####
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
  } else stop("One of 'whichForms' and 'whichItems' should be NULL.")
  return(out)
}


#### function that creates an S3 class 'constraint' ####
newConstraint <- function(A_binary, A_real = NULL, operators, d,
                          nReal = NULL,
                          nForms, nItems, sense = NULL, info){

  ### check input
  # check if A_binary is a Matrix
  stopifnot(inherits(A_binary, "Matrix"))

  # check if operators, d, and info correspond with A_binary
  nRow <- dim(A_binary)[1]
  stopifnot(all(c(length(operators), length(d), dim(info)[1]) == nRow))

  # check if A_binary corresponds with nForms and nItems
  stopifnot(dim(A_binary)[2] == (nForms * nItems))

  # check dims of A_real
  if(is.null(nReal)) {
    stopifnot(is.null(A_real))
    stopifnot(is.null(sense))
    }
  else stopifnot(all(dim(A_real) == c(nRow, nReal)))

  # check sense
  if(!is.null(sense)) sense <- match.arg(sense, choices = c("min", "max"))

  # check opertors
  stopifnot(operators %in% c("<=", "=", ">="))

  out <- list(A_binary = A_binary,
              A_real = A_real,
              operators = operators,
              d = d)

  structure(out,
            class = "constraint",
            nForms = nForms,
            nItems = nItems,
            nReal = nReal,
            sense = sense,
            info = info)
}



#### function that creates constraints per form - general ####
makeFormConstraint <- function(nForms, nItems, itemValues, realVar, operator,
                               targetValue, whichForms, sense,
                               info_text = NULL){


  # number of used forms in constraints
  nUsedForms <- length(whichForms)

  # A matrix with weights - only for binary variables
  A_binary <- get_A_binary_forms(nForms, nItems, itemValues, whichForms)

  # A matrix with weights - only for real variables
  A_real <- 'if'(is.null(realVar), realVar, matrix(rep(realVar, each = nUsedForms), nrow = nUsedForms))
  nReal <- 'if'(is.null(A_real), NULL, dim(A_real)[2])

  # vector with operators
  operators <- rep(operator, nUsedForms)

  # rhs d vector with target values
  d <- rep(targetValue, nUsedForms)

  # data.frame with information about the constraint
  info <- make_info('if'(is.null(info_text),
                         deparse(substitute(itemValues)),
                         info_text), whichForms = whichForms)

  # make constraint object
  newConstraint(A_binary, A_real, operators, d, nReal,
                nForms, nItems, sense, info)

}


#### function that creates constraints per item - general ####
makeItemConstraint <- function(nForms, nItems, formValues, realVar, operator,
                               targetValue, whichItems, sense,
                               info_text = NULL){


  # number of used forms in constraints
  nUsedItems <- length(whichItems)

  # A matrix with weights - only for binary variables
  A_binary <- get_A_binary_items(nForms, nItems, formValues, whichItems)

  # A matrix with weights - only for real variables
  A_real <- 'if'(is.null(realVar), realVar, matrix(rep(realVar, each = nUsedItems), nrow = nUsedItems))
  nReal <- 'if'(is.null(A_real), NULL, dim(A_real)[2])

  # vector with operators
  operators <- rep(operator, nUsedItems)

  # rhs d vector with target values
  d <- rep(targetValue, nUsedItems)

  # data.frame with information about the constraint
  info <- make_info('if'(is.null(info_text),
                         deparse(substitute(formValues)),
                         info_text), whichItems = whichItems)

  # make constraint object
  newConstraint(A_binary, A_real, operators, d, nReal,
                nForms, nItems, sense, info)

}



#### function to combine two constraints ####
combine2Constraints <- function(x, y){

  # check if both x and y are of class constraint
  if(!all(inherits(x, "constraint"), inherits(y, "constraint"))) stop("Both arguments should be of class 'constraint'")


  # check if nForms and nItems are the same
  if(attr(x, "nForms") != attr(y, "nForms")) stop("The constraints cannot be combined, the number of forms differs.")
  if(attr(x, "nItems") != attr(y, "nItems")) stop("The constraints cannot be combined, the number of items in the pool differs.")


  # check nReal and adjust nReal and A_real where necessary
  if(is.null(attr(x, "nReal")) & !is.null(attr(y, "nReal"))){
    nReal <- attr(y, "nReal")
    x$A_real <- matrix(0, nrow = dim(x$A_binary)[1], ncol = nReal)
  } else if(is.null(attr(y, "nReal")) & !is.null(attr(x, "nReal"))){
    nReal <- attr(x, "nReal")
    y$A_real <- matrix(0, nrow = dim(y$A_binary)[1], ncol = nReal)
  } else if(!is.null(attr(x, "nReal")) & !is.null(attr(y, "nReal"))){
    if(attr(x, "nReal") > attr(y, "nReal")){
      warning("Are you sure you want to combine the constraints? The number of real variables (in the objective function) differs.")
      nReal <- attr(x, "nReal")
      y$A_real <- cbind(y$A_real, matrix(0, nrow = dim(y$A_real)[1], ncol = nReal - attr(y, "nReal")))
    }
    if(attr(x, "nReal") > attr(y, "nReal")){
      warning("Are you sure you want to combine the constraints? The number of real variables (in the objective function) differs.")
      nReal <- attr(y, "nReal")
      x$A_real <- cbind(x$A_real, matrix(0, nrow = dim(x$A_real)[1], ncol = nReal - attr(x, "nReal")))
    }
  } else nReal <- attr(x, "nReal")


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
                nReal = nReal,
                nForms = attr(x, "nForms"),
                nItems = attr(x, "nItems"),
                sense = sense,
                info = info)
}



#### function to combine multiple constraints ####
combineConstraints <- function(...){

  dots <- list(...)
  dots <- 'if'(length(dots) == 1 && !inherits(dots[[1]], "constraint"), dots[[1]], dots)

  # check if all objects are of class constraints
  if(!all(sapply(dots, inherits, what = "constraint"))) stop("All arguments should be of the 'constraint'-class.")

  if(length(dots) == 1){
    message("The one constraint that was given is simply returned")
    return(dots)
  } else if (length(dots) == 2){
    return(combine2Constraints(dots[[1]], dots[[2]]))
  } else if (length(dots) > 2){
    c12 <- combine2Constraints(dots[[1]], dots[[2]])
    dots <- append(dots[-c(1:2)], list(c12), after = 0)
    return(combineConstraints(dots))
  } else stop("No constraints were included")
}


