#############################################################################
#' Calculate Item Information Function
#'
#' Calculate item information function given item parameters of the 1PL, 2PL or 3PL IRT model.
#'
#'@param theta Vector of time intensity parameters.
#'@param A Vector of discrimination parameters.
#'@param B Vector of difficulty parameters.
#'@param C Vector of pseudo-guessing parameters.
#'@param D the constant that should be used. Defaults to 1.7.
#'
#'@return a matrix, with columns for different \code{theta} and rows for different items
#'
#'@references van der Linden, W. J. (2005). \emph{Linear models for optimal test design}. New York, NY: Springer.
#'
#'@examples
#'# TIF for a single item (2PL model)
#'calculateIIF(A = 0.8, B = 1.1, theta = 0)
#'
#'# TIF for multiple items (1PL model)
#'calculateIIF(B = c(1.1, 0.8, 0.5), theta = 0)
#'
#'# TIF for multiple theta-values (3PL model)
#'calculateIIF(B = -0.5, C = 0.25, theta = c(-1, 0, 1))
#'
#'# TIF for multiple items and multiple ability levels (2PL model)
#'calculateIIF(A = c(0.7, 1.1, 0.8), B = c(1.1, 0.8, 0.5),
#'             theta = c(-1, 0, 1))
#'
#'@export
calculateIIF <- function(A = rep(1, length(B)), B, C = rep(0, length(B)), theta, D = 1.7) {
  if(!is.numeric(theta)) stop("'theta' must be a numeric vector.")
  if(!is.numeric(A)) stop("'A' must be a numeric vector.")
  if(!is.numeric(B)) stop("'B' must be a numeric vector.")
  if(!is.numeric(C)) stop("'C' must be a numeric vector.")
  if(length(A) != length(B) || length(A) != length(C)) stop("'A', 'B', and 'C' must be of the same length.")

  # matrix form A and C
  nP <- length(theta)
  Am <- rep(D, nP) %o% A
  Cm <- rep(1, nP) %o% C

  # compute probabilities
  P <- Cm + (1 - Cm) / (1 + exp(- Am * outer(theta, B, "-")))

  # compute IIF
  IIFs <- t(Am^2 * ((P - Cm)/(1 - Cm))^2 * (1 - P)/P)

  colnames(IIFs) <- paste0("theta=", theta)
  return(IIFs)
}

