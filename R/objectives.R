#' Minimax Constraint.
#'
#' Create \code{minimax}-constraints related to an item parameter/value. That is, the created
#' constraints can be used to minimize the maximum distance between the sum of the
#' item values (\code{itemValues}) per test form and the chosen \code{targetValue}.
#'
#'@inheritParams itemValuesConstraint
#'@param weight a weight for the real-valued variable(s). Useful when multiple constraints are combined. Should only be used if the implications are well understood.
#'
#'@return An object of class \code{"constraint"}.
#'
#'@examples
#'# constraint that minimizes the maximum difference per test form value and a
#'#   target value of 0
#'minimaxObjective(nForms = 2,
#'                  itemValues = rep(-2:2, 2),
#'                  targetValue = 0)
#'
#'@export
minimaxObjective <- function(nForms, itemValues, targetValue, weight = 1,
                              whichForms = seq_len(nForms), info_text = NULL,
                              itemIDs = names(itemValues)){

  # choose info_text for info
  if(is.null(info_text)) info_text <- 'minimax'

  lowerBound <- makeFormConstraint(nForms, itemValues, realVar = -weight,
                                   operator = "<=", targetValue,
                                   whichForms, sense = "min", c_real = 1,
                                   info_text = paste0(info_text, "_lowerBound"),
                                   itemIDs = itemIDs)

  upperBound <- makeFormConstraint(nForms, itemValues, realVar = weight,
                                   operator = ">=", targetValue,
                                   whichForms, sense = "min", c_real = 1,
                                   info_text = paste0(info_text, "_upperBound"),
                                   itemIDs = itemIDs)

  combine2Constraints(lowerBound, upperBound)
}



#' Maximin Constraint.
#'
#' Create \code{maximin}-constraints related to an item parameter/value. That is, the created
#' constraints can be used to maximize the minimal sum of the
#' item values (\code{itemValues}), while at the same time setting an upper limit to the
#' overflow by means of a maximally allowed deviation \code{allowedDeviation}.
#'
#'@inheritParams itemValuesConstraint
#'@inheritParams minimaxObjective
#'@param allowedDeviation the maximum allowed deviation between the sum of the target values.
#'
#'@return An object of class \code{"constraint"}.
#'
#'@examples
#'# constraint that minimizes the maximum difference per test form value and a
#'#   target value of 0
#'maximinObjective(nForms = 2, itemValues = rep(-2:2, 2),
#'                  allowedDeviation = 1)
#'
#'@export
maximinObjective <- function(nForms, itemValues, allowedDeviation,
                              weight = 1, whichForms = seq_len(nForms), info_text = NULL,
                              itemIDs = names(itemValues)){

  # check allowed deviation
  if(length(allowedDeviation) > 1) stop("'allowedDeviation' should have length 1.")
  if(allowedDeviation <= 0) stop("'allowedDeviation' should be a positive value.")

  # choose info_text for info
  if(is.null(info_text)) info_text <- 'maximin'

  lowerBound <- makeFormConstraint(nForms, itemValues, realVar = -weight,
                                   operator = ">=", targetValue = 0,
                                   whichForms, sense = "max", c_real = 1,
                                   info_text = paste0(info_text, "_lowerBound"),
                                   itemIDs = itemIDs)


  upperBound <- makeFormConstraint(nForms, itemValues, realVar = -weight,
                                   operator = "<=", targetValue = allowedDeviation*weight,
                                   whichForms, sense = NULL, c_real = 1,
                                   info_text = paste0(info_text, "_upperBound"),
                                   itemIDs = itemIDs)

  combine2Constraints(lowerBound, upperBound)
}


#' CappedMaximin Constraint.
#'
#' Create \code{maximin}-constraints related to an item parameter/value. That is, the created
#' constraints can be used to maximize the minimal sum of the
#' item values (\code{itemValues}), while at the same time automatically setting
#' an ideal upper limit to the overflow. More specifically, the \code{capped minimax}
#' method described by Luo (2020) is used.
#'
#'@inheritParams itemValuesConstraint
#'@inheritParams minimaxObjective
#'
#'@return An object of class \code{"constraint"}.
#'
#'@examples
#'# constraint that minimizes the maximum difference per test form value and a
#'#   target value of 0
#'cappedMaximinObjective(nForms = 2, itemValues = rep(-2:2, 2))
#'
#'@references Xiao Luo (2020). Automated Test Assembly with Mixed-Integer Programming:
#'The Effects of Modeling Approaches and Solvers.
#'\emph{Journal of Educational Measurement}, 57(4), 547-565.
#'\url{https://onlinelibrary.wiley.com/doi/10.1111/jedm.12262}
#'
#'@export
cappedMaximinObjective <- function(nForms, itemValues, weight = 1,
                                    whichForms = seq_len(nForms), info_text = NULL,
                                    itemIDs = names(itemValues)){


  # choose info_text for info
  if(is.null(info_text)) info_text <- 'cappedMaximin'

  lowerBound <- makeFormConstraint(nForms, itemValues, realVar = c(-weight, 0),
                                   operator = ">=", targetValue = 0,
                                   whichForms, sense = "max", c_real = c(1, -1),
                                   info_text = paste0(info_text, "_lowerBound"),
                                   itemIDs = itemIDs)


  upperBound <- makeFormConstraint(nForms, itemValues, realVar = c(-weight, -weight),
                                   operator = "<=", targetValue = 0,
                                   whichForms, sense = NULL, c_real = c(1, -1),
                                   info_text = paste0(info_text, "_upperBound"),
                                   itemIDs = itemIDs)

  combine2Constraints(lowerBound, upperBound)
}




#' Max Constraint.
#'
#' Create \code{max}-constraints related to an item parameter/value. That is, the created
#' constraints can be used to maximize the sum of the
#' item values (\code{itemValues}) of the test form.
#' Note that this constraint can only be used when only one test form has to be assembled.
#'
#'@inheritParams itemValuesConstraint
#'@inheritParams minimaxObjective
#'
#'@return An object of class \code{"constraint"}.
#'
#'@examples
#'# constraint that maximizes the sum of the itemValues
#'maxObjective(nForms = 1, itemValues = rep(-2:2, 2))
#'
#'@export
maxObjective <- function(nForms, itemValues, weight = 1,
                          whichForms = seq_len(nForms), info_text = NULL,
                          itemIDs = names(itemValues)){

  # choose info_text for info
  if(is.null(info_text)) info_text <- 'max'

  makeFormConstraint(nForms = nForms, itemValues, realVar = -weight,
                     operator = ">=", targetValue = 0, sense = "max",
                     c_real = 1, whichForms = whichForms,
                     info_text = info_text,
                     itemIDs = itemIDs)
}


#' Min Constraint.
#'
#' Create \code{min}-constraints related to an item parameter/value. That is, the created
#' constraints can be used to minimize the sum of the
#' item values (\code{itemValues}) of the test form.
#' Note that this constraint can only be used when only one test form has to be assembled.
#'
#'@inheritParams itemValuesConstraint
#'@inheritParams minimaxObjective
#'
#'@return An object of class \code{"constraint"}.
#'
#'@examples
#'# constraint that maximizes the sum of the itemValues
#'maxObjective(nForms = 1, itemValues = rep(-2:2, 2))
#'
#'@export
minObjective <- function(nForms, itemValues, weight = 1,
                          whichForms = seq_len(nForms), info_text = NULL,
                          itemIDs = names(itemValues)){

  # choose info_text for info
  if(is.null(info_text)) info_text <- 'min'

  makeFormConstraint(nForms = nForms, itemValues, realVar = -weight,
                     operator = "<=", targetValue = 0, sense = "min",
                     c_real = 1, whichForms = whichForms,
                     info_text = info_text,
                     itemIDs = itemIDs)
}
