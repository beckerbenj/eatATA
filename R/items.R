####
#############################################################################
#' Small artificial item pool example.
#'
#' A \code{data.frame} containing 80 items with different categorical and metric properties.
#'
#' @format A \code{data.frame} .
#'\describe{
#' \item{Item_ID}{Item identifier.}
#' \item{exclusions}{Items which can not be in the same test form.}
#' \item{RT_in_min}{Average response times in minutes.}
#' \item{subitems}{Number of sub items.}
#' \item{MC, CMC, short_answer, open}{Answer formats.}
#' \item{diff_1, diff_2, diff_3, diff_4, diff5}{Difficulty categories.}
#' }
"items"
