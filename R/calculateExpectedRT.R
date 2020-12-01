#############################################################################
#' Calculate Expected Response Times
#'
#' Calculate expected response times given item parameters of the log normal response time model.
#'
#' Expected response times are calculated according to the log normal response time models by
#' van der Linden (2006) or Klein Entink et al. (2009). If \code{phi} is \code{1}, the model
#' by van der Linden (2006) is used. Either a single set of parameters of vectors of each parameters
#' can be supplied. If multiple \code{zeta} are supplied
#'
#'@param lambda Vector of time intensity parameters.
#'@param phi Vector of time sensitivity parameters.
#'@param zeta Vector of person speed parameters.
#'@param sdEpsi Vector of item specific residual variances.
#'
#'@return a vector
#'
#'@export
calculateExpectedRT <- function(lambda, phi, zeta, sdEpsi) {
  cumulants <- getCumulantRT(zeta, lambda, phi, sdEpsi)
  return(t(cumulants[[1]]))
}


### Function to compute the first, second and third cumulant of the
### item response time function.
###   lambda = time intensity parameter (item)
###   phi    = speed sensitivity parameter (item)
###   zeta   = speed parameter (person)
###   sdEpsi = standard deviation of the log response time distribution (item)
getCumulantRT <- function(zeta, lambda, phi, sdEpsi){
  ONEs <- rep(1, length(zeta))
  exponent <- outer(- zeta, phi) + outer(ONEs, (lambda + (sdEpsi^2) / 2))
  # not vectorized: lambda - (zeta * phi) + (sdEpsi^2)/2

  # see Fenton, L. F. (1960) equations: (8) and (21)
  cum1 <- exp(exponent)
  cum2 <- exp(2 * exponent) * (exp(outer(ONEs, sdEpsi^2)) - 1)
  cum3 <- exp(3 * exponent) * (exp(outer(ONEs, 3 * sdEpsi^2))
                               - 3 * exp(outer(ONEs, sdEpsi^2)) + 2)

  # give rownames
  rownames(cum1) <- rownames(cum2) <- rownames(cum3) <- paste0(
    deparse(substitute(zeta)), "=", zeta)
  return(list(cum1 = t(cum1),
              cum2 = t(cum2),
              cum3 = t(cum3)))
}
