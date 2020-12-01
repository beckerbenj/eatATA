#############################################################################
#' Calculate Item Information Function
#'
#' Calculate item information function given item parameters of the 1PL, 2PL or 3PL IRT model.
#'
#'@param theta Vector of time intensity parameters.
#'@param A Vector of discrimination parameters.
#'@param B Vector of difficulty parameters.
#'@param C Vector of guessing parameters.
#'@param D A constant.
#'
#'@return a matrix, with columns for different \code{theta} and rows for different items
#'
#'@export
calculateIIF <- function(theta, A = rep(1, length(B)),
                    B = 0, C = rep(0, length(B)), D = 1.7) {
  if(!is.numeric(theta)) stop("'theta' must be a numeric vector.")
  if(!is.numeric(A)) stop("'A' must be a numeric vector.")
  if(!is.numeric(B)) stop("'B' must be a numeric vector.")
  if(!is.numeric(C)) stop("'C' must be a numeric vector.")
  if(!is.numeric(D)) stop("'D' must be a numeric vector.")
  if(length(A) != length(B) || length(A) != length(C)) stop("'A', 'B', and 'C' must be of the same length.")

  # compute P* and Q*
  P <- resProbs(theta, A, B, C, D)

  # matrix form A and C
  nP <- length(theta)
  Am <- rep(D, nP) %o% A
  Cm <- rep(1, nP) %o% C

  IIFs <- Am^2 * ((P - Cm)/(1 - Cm))^2 * (1 - P)/P
  t(IIFs)
}
### Function to compute response probabilities for 1-, 2-, and 3PL (with vectors)
resProbs <- function(Theta, A = rep(1, length(B)), B = 0, C = rep(0, length(B)), D = 1.7)
{
  # check if all arguments are vectors
  stopifnot(all(sapply(c(Theta, A, B, C), is.vector, mode = "double")))

  # number of test takers and items
  nP <- length(Theta)
  nI <- length(B)

  # check if A, B and C are of same length
  stopifnot(all(sapply(list(A, B, C), function(x) {length(x) == nI})))

  # linear term
  mu <- (rep(D, nP) %o% A) * outer(Theta, B, "-")
  Cm <- rep(1, nP) %o% C

  prob <- Cm + (1 - Cm) * (1 + exp(- mu))^(-1)
  return(prob)
}



### Function to calculate Item Information conditional on ability
calc_IIF <- function(A, B, C, theta) {
  stopifnot(identical(length(A), length(B)))

  J <- length(theta)
  Info <- array(0,c(length(A),J))
  for(j in 1:J){
    P <- C+(1-C)/(1+exp(-1.7*A*(theta[j]-B))) ## Prob of correct response
    Q <- 1-P
    Info[,j] <- (1.7^2)*(A^2)*((P-C)/(1-C))^2*Q/P ## item information for corresponding theta value??
  }
  Info
}


#calculateIIF(theta = 0:1, A = c(1), B =c(0), C= c(0))
#calculateIIF(theta = 0:1, A = c(1, 1), B =c(0, 5), C= c(0, 0))
#calc_IIF(theta = 0:1, A = c(1), B =c(0), C= c(0))
#calc_IIF(theta = 0:1, A = c(1, 1), B =c(0, 5), C= c(0, 0))
