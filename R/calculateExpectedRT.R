#############################################################################
#' Calculate Cumulants Lognormal Response Time Distribution
#'
#' These functions have been deprecated. See \code{\link{get_mean_3PLN}} or \code{\link{get_var_3PLN}} instead.
#'
#'@param lambda Vector of time intensity parameters.
#'@param phi [optional] Vector of speed sensitivity parameters.
#'@param zeta Vector of person speed parameters.
#'@param sdEpsi Vector of item specific residual variances.
#'
#'
#' @describeIn get_mean_3PLN Calculate mean 3PLN
#'@export
calculateExpectedRT <- function(lambda, phi, zeta, sdEpsi) {
  stop("This function is deprecated. See '?get_mean_3PLN' for more details.")
}

#' @describeIn get_mean_3PLN Calculate mean 2PLN
#'@export
calculateExpectedRTvar <- function(lambda, phi, zeta, sdEpsi) {
  stop("This function is deprecated. See '?get_var_3PLN' for more details.")
}

