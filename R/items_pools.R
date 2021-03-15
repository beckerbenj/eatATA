####
#############################################################################
#' Small simulated item pool example.
#'
#' A \code{data.frame} containing 30 items with different categorical and metric properties.
#'
#' @format A \code{data.frame} .
#'\describe{
#' \item{item}{Item identifier.}
#' \item{format}{Item format (e.g., multiple choice, open answer, order item).}
#' \item{time}{Average response time in seconds.}
#' \item{difficulty}{IRT difficulty parameter.}
#' }
"items_mini"

####
#############################################################################
#' Small simulated item pool example.
#'
#' A \code{data.frame} containing 165 items calibrated using a 3PL model. This item pool is analogous to one of the item pools used
#' in Diao & van der Linden (2011).
#'
#' @format A \code{data.frame} .
#'\describe{
#' \item{item}{Item identifier.}
#' \item{a}{Discrimination parameter.}
#' \item{b}{Difficulty parameter.}
#' \item{c}{Pseudo-guessing parameter.}
#' \item{category}{Content category.}
#' }
#'
#' @references Diao, Q. & van der Linden, W.J. (2011). Automated test assembly using lp_solve version 5.5 in R. \emph{Applied Psychological Measurement, 35 (5)}, 398-409.
#
"items_diao"

####
#############################################################################
#' Small simulated item pool example.
#'
#' A \code{data.frame} containing 100 not yet calibrated items with different categorical and metric properties.
#'
#' @format A \code{data.frame} .
#'\describe{
#' \item{item}{Item identifier.}
#' \item{diffCategory}{Item difficulty (five categories).}
#' \item{format}{Item format (multiple choice, constructed multiple choice, or open answer).}
#' \item{domain}{Item domain (listening, reading, or writing).}
#' \item{time}{Average response times in seconds.}
#' \item{exclusions}{Items which can not be in the same test form.}
#' }
"items_pilot"

####
#############################################################################
#' Simulated item pool example.
#'
#' A \code{data.frame} containing 209 calibrated items with different categorical and metric properties, comparable to an item pool from a large-scale
#' assessment.
#'
#' @format A \code{data.frame} .
#'\describe{
#' \item{testlet}{Testlet identifier (items in the same testlet share a common stimulus.}
#' \item{item}{Item identifier.}
#' \item{level}{Competence level.}
#' \item{format}{Item format.}
#' \item{frequency}{Solution frequency.}
#' \item{infit}{Item infit.}
#' \item{time}{Average response time in seconds.}
#' \item{anchor}{Is the item an anchor item?}
#' }
"items_lsa"

####
#############################################################################
#' Small artificial item pool example.
#'
#' A \code{data.frame} containing 80 items with different categorical and metric properties.
#'
#' @format A \code{data.frame} .
#'\describe{
#' \item{item}{Item identifier.}
#' \item{exclusions}{Items which can not be in the same test form.}
#' \item{time}{Average response times in minutes. \code{2.5} equals 2 minutes and 30 seconds, for example.}
#' \item{subitems}{Number of sub items.}
#' \item{MC, CMC, short_answer, open}{Answer formats.}
#' \item{diff_1, diff_2, diff_3, diff_4, diff5}{Difficulty categories.}
#' }
"items_vera"
