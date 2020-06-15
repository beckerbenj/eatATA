

###
# ---------------------------------------------------------------------------------------------------
####
#############################################################################
#' Prepare a list of constraints for \code{Gurobi}.
#'
#' tbd
#'
#'@param allConstraints Number of forms to be created.
#'@param M tbd
#'@param n_items tbd
#'@param f tbd
#'
#'@return tbd
#'
#'@examples
#' #tbd
#'
#'@export
prepareConstraints <- function(allConstraints, M, n_items, f) {
  stopifnot(is.list(allConstraints))
  #if(!identical(names(allConstraints), c("nrItems", "ItemOverlap", "tif", "speed"))) {
  #  stopifnot(identical(names(allConstraints), c("nrItems", "ItemOverlap", "tif")))
  #  warning("Speed constraints are missing!")
  #}
  #allConstraints <- list(...)
  Ad <- do.call(rbind, allConstraints)
  dim(Ad)

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
               obj = c(rep(0, n_items*f), 1),
               modelsense = "min",
               vtype = c(rep("B", n_items*f), "C"))
  MILP
}




