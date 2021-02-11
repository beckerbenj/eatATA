####
#############################################################################
#' Small simulated item pool example.
#'
#' A \code{data.frame} containing 100 uncalibrated items with different categorical and metric properties.
#'
#' @format A \code{data.frame} .
#'\describe{
#' \item{Item}{Item identifier.}
#' \item{diff}{Item difficulty (five categories).}
#' \item{format}{Item format (multiple choice, constructed multiple choice, or open answer).}
#' \item{domain}{Item domain (listening, reading, or writing).}
#' \item{mean_time}{Average response times in seconds.}
#' \item{exclusions}{Items which can not be in the same test form.}
#' }
"items_pilot"
