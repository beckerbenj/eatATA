#' Combine constraints
#'
#' Combine multiple constraint-objects into one constraint object.
#'
#'@param ... multiple constraint-objects or a list with multiple constraint-objects
#'@param message A logical indicating whether a message should be given when only one constraint object is combined.
#'
#'@return A \code{data.frame} of block exclusions.
#'
#'@examples
#'combineConstraints(
#'  itemValuesConstraint(2, 1:10, operator = ">=", targetValue = 4),
#'  itemValuesConstraint(2, 1:10, operator = "<=", targetValue = 6)
#')
#'
#'@export
combineConstraints <- function(..., message = TRUE){

  dots <- list(...)
  dots <- 'if'(length(dots) == 1 && !inherits(dots[[1]], "constraint"), dots[[1]], dots)

  # check if all objects are of class constraints
  if(!all(sapply(dots, inherits, what = "constraint"))) stop("All arguments should be of the 'constraint'-class.")

  if(length(dots) == 1){
    if(message) message("The one constraint that was given is simply returned")
    return(dots[[1]])
  } else if (length(dots) == 2){
    return(combine2Constraints(dots[[1]], dots[[2]]))
  } else if (length(dots) > 2){
    c12 <- combine2Constraints(dots[[1]], dots[[2]])
    dots <- append(dots[-c(1:2)], list(c12), after = 0)
    return(combineConstraints(dots))
  } else stop("No constraints were included")
}


### S3 methods for constraint object
#'@export
c.constraint <- function(...){
  message("'combineConstraints()' is used under the hood. Please use 'combineConstraints' directly.")
  combineConstraints(...)
}

