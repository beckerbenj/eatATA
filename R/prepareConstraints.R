####
#############################################################################
#' Prepare a list of constraints for \code{Gurobi}
#'
#' Transform a list of constraints set up via \code{eatATA} as input to the \code{gurobi} function.
#'
#'@param allConstraints List of constraints.
#'@param nForms Number of forms to be created.
#'@param nItems Number of items in the item pool.
#'
#'@return A \code{gurobi} model list.
#'
#'@examples
#' ## setup some example constraints
#' usage <- itemUsageConstraint(nForms = 2, nItems = 10, operator = "=", targetValue = 1)
#' perForm <- itemsPerFormConstraint(nForms = 2, nItems = 10, operator = "=", targetValue = 5)
#' target <- itemTargetConstraint(nForms = 2, nItems = 10, itemValues = 1:10, targetValue = 5)
#'
#' ## Prepare Constraints
#' prepareConstraints(list(usage, perForm, target), nForms = 2, nItems = 10)
#'
#'@export
prepareConstraints <- function(allConstraints, nForms, nItems) {
  if(!is.list(allConstraints)) stop("allConstraints needs to be a list.")
  if(!all(sapply(allConstraints, function(x) "dgCMatrix" %in% class(x)))) stop("All elements in allConstraints need to be matrices.")

  ## Further tests: identical ncols... optimzitation via M test?

  Ad <- do.call(rbind, allConstraints)
  M <- nItems*nForms+1        # decision variable

  # sense of the constraints
  sense <- as.vector(Ad[,(M+1)])
  sense[which(sense==-1)] <- "<="
  sense[which(sense==0)] <- "="
  sense[which(sense==1)] <- ">="

  A <- Ad[,1:M]
  A <- as.matrix(A)

  MILP <- list(A = A,
               rhs = as.vector(Ad[,(M+2)]),
               sense = sense,
               obj = c(rep(0, nItems*nForms), 1),
               modelsense = "min",
               vtype = c(rep("B", nItems*nForms), "C"))
  MILP
}




