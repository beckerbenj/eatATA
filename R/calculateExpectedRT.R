#############################################################################
#' Calculate Expected Response Times
#'
#' Calculate expected response times given item parameters of the log normal response time model.
#'
#' Expected response times are calculated according to the log normal response time model by
#' van der Linden (2006) or Klein Entink et al. (2009). If \code{phi} is \code{1}, the model
#' by van der Linden (2006) is used. Either a single set of parameters of vectors of each parameters
#' can be supplied.
#'
#' The calculation is based on Fenton (1960). For the model by van der Linden (2006), the calculation was
#' first introduced by van der Linden (2011).
#'
#'@param lambda Vector of time intensity parameters.
#'@param phi [optional] Vector of time sensitivity parameters.
#'@param zeta Vector of person speed parameters.
#'@param sdEpsi Vector of item specific residual variances.
#'
#'@return a matrix, with columns for different \code{zeta} and rows for different items
#'
#'@references Fenton, L. (1960). The sum of log-normal probability distributions in scatter transmission systems. \emph{IRE
#' Transactions on Communication Systems}, 8, 57-67.
#'
#' Klein Entink, R. H., Fox, J.-P., & van der Linden, W. J. (2009). A multivariate
#'multilevel approach to the modeling of accuracy and speed of test
#'takers. \emph{Psychometrika}, 74(1), 21-48.
#'
#'van der Linden, W. J. (2006). A lognormal model for response times on test
#'items. \emph{Journal of Educational and Behavioral Statistics, 31(2),
#'181-204}.
#'
#'van der Linden, W. J. (2011). Test design and speededness. \emph{Journal of
#'Educational Measurement}, 48(1), 44-60.
#'
#'@examples
#'# expected RT for a single item (van der Linden model)
#'calculateExpectedRT(lambda = 3.8, zeta = 0, sdEpsi = 0.3)
#'
#'# expected RT for multiple items (van der Linden model)
#'calculateExpectedRT(lambda = c(4.1, 3.8, 3.5), zeta = 0,
#'                    sdEpsi = c(0.3, 0.4, 0.2))
#'
#'# TIF for multiple items and multiple ability levels (1PL model)
#'calculateExpectedRT(lambda = c(3.7, 4.1, 3.8), phi = c(1.1, 0.8, 0.5),
#'                     zeta = c(-1, 0, 1), sdEpsi = c(0.3, 0.4, 0.2))
#'
#'@export
calculateExpectedRT <- function(lambda, phi = rep(1, length(lambda)), zeta, sdEpsi) {
  if(!is.numeric(lambda)) stop("'lambda' must be a numeric vector.")
  if(!is.numeric(phi)) stop("'phi' must be a numeric vector.")
  if(!is.numeric(zeta)) stop("'zeta' must be a numeric vector.")
  if(!is.numeric(sdEpsi)) stop("'sdEpsi' must be a numeric vector.")
  if(length(sdEpsi) != length(lambda) || length(sdEpsi) != length(phi)) stop("'lambda', 'phi', and 'sdEpsi' must be of the same length.")

  cumulants <- getCumulantRT(zeta, lambda, phi, sdEpsi)
  return(cumulants[[1]])
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
