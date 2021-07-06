#' Constrain the sum of item values per form.
#'
#' \loadmathjax Create constraints related to an item parameter/value. That is, the created
#' constraints assure that the sum of the item values (\code{itemValues}) per test form is either
#' (a) smaller than or equal to (\code{operator = "<="}), (b) equal to
#' (\code{operator = "="}), or (c) greater than or equal to (\code{operator = ">="})
#' the chosen \code{targetValue}.
#'
#' When \code{operator} is \code{"<="}, the constraint can be mathematically formulated as:
#' \mjsdeqn{\sum_{i=1}^{I} v_i \times x_{if} \leq t , \; \; \; \code{for} \:  f \in G,}
#' where \mjseqn{I} refers to the number of items in the item pool, \mjseqn{v_i} is the
#' \code{itemValue} for item \mjseqn{i} and \mjseqn{t} is the \code{targetValue}. Further, \mjseqn{G}
#' corresponds to \code{whichForms}, so that the above inequality constraint
#' is repeated for every test form \mjseqn{f} in \mjseqn{G}. In addition, let \mjseqn{\boldsymbol{x}}
#' be a vector of binary decision variables with length \mjseqn{I \times F}, where \mjseqn{F}
#' is \code{nForms}. The binary decision variables \mjseqn{x_{if}} are defined as:
#' \tabular{lll}{
#' \mjseqn{\;\;\;\;\;\;\;\;} \tab \mjseqn{x_{if} = 1},\mjseqn{\;\;\;\;}  \tab if item \mjseqn{i} is assigned to form \mjseqn{f}, and  \cr
#' \mjseqn{\;\;\;\;\;\;\;\;} \tab \mjseqn{x_{if} = 0},\mjseqn{\;\;\;\;}  \tab otherwise.
#' }
#'
#'
#'@param nForms Number of forms to be created.
#'@param itemValues Item parameter/values for which the sum per test form should be constrained.
#'@param operator A character indicating which operator should be used in the
#'  constraints, with three possible values: \code{"<="}, \code{"="},
#'  or \code{">="}. See details for more information.
#'@param targetValue the target test form value.
#'@param whichForms An integer vector indicating which test forms should be constrained. Defaults to all the test forms.
#'@param info_text a character string of length 1, to be used in the \code{"info"}-attribute of the resulting \code{constraint}-object.
#'@param itemIDs a character vector of item IDs in correct ordering, or NULL.
#'
#'@return An object of class \code{"constraint"}.
#'
#'@examples
#' ## constraints to make sure that the sum of the item values (1:10) is between
#' ## 4 and 6
#' combineConstraints(
#'   itemValuesConstraint(2, 1:10, operator = ">=", targetValue = 4),
#'   itemValuesConstraint(2, 1:10, operator = "<=", targetValue = 6)
#' )

#'
#'@export
itemValuesConstraint <- function(nForms, itemValues,
                                 operator = c("<=", "=", ">="),
                                 targetValue, whichForms = seq_len(nForms),
                                 info_text = NULL,
                                 itemIDs = names(itemValues)){

  # Do checks
  check_out <- do_checks_eatATA(
    nItems = NULL,
    itemIDs = itemIDs,
    itemValues = itemValues,
    operator = operator,
    nForms = nForms,
    targetValue = targetValue,
    info_text = info_text,
    whichItems = NULL,
    itemValuesName = deparse(substitute(itemValues)))

  nItems <- check_out$nItems
  itemIDs <- check_out$itemIDs
  itemValues <- check_out$itemValues
  operator <- check_out$operator
  info_text <- check_out$info_text


  # the targetValue should be smaller than or equal to the sum of the itemValues
  if(targetValue > sum(itemValues)) stop("The 'targetValue' should be smaller than the sum of the 'itemValues'.")


  makeFormConstraint(nForms, itemValues, realVar = NULL,
                     operator, targetValue,
                     whichForms, sense = NULL,
                     info_text = info_text,
                     itemIDs = itemIDs)
}
