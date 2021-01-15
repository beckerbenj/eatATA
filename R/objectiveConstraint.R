#' Minimax Constraint.
#'
#' Create a minimax-constraints related to an item parameter/value. That is, the created
#' constraints can be used to minimize the maximum distance between the sum of the
#' item values (\code{itemValues}) per test form and the chosen \code{targetValue}.
#'
#'@inheritParams itemValuesConstraint
#'
#'@return An object of class \code{"constraint"}.
#'
#'@examples
#'# constraint that minimizes the maximum difference per test form value and a
#'#   target value of 0
#'minimaxConstraint(nForms = 2, nItems = 10,
#'                  itemValues = rep(-2:2, 2),
#'                  targetValue = 0)
#'
#'@export
minimaxConstraint <- function(nForms, nItems, itemValues, targetValue,
                              whichForms = seq_len(nForms), info_text = NULL,
                              itemIDs = names(itemValues)){

  # choose info_text for info
  if(is.null(info_text)) info_text <- 'minimax'

  lowerBound <- makeFormConstraint(nForms, nItems, itemValues, realVar = -1,
                                   operator = "<=", targetValue,
                                   whichForms, sense = "min", c_real = 1,
                                   info_text = paste0(info_text, "_lowerBound"),
                                   itemIDs = itemIDs)

  upperBound <- makeFormConstraint(nForms, nItems, itemValues, realVar = 1,
                                   operator = ">=", targetValue,
                                   whichForms, sense = "min", c_real = 1,
                                   info_text = paste0(info_text, "_upperBound"),
                                   itemIDs = itemIDs)

  combine2Constraints(lowerBound, upperBound)
}



#' Maximin Constraint.
#'
#' Create a maximin-constraints related to an item parameter/value. That is, the created
#' constraints can be used to maximize the minimal sum of the
#' item values (\code{itemValues}), while at the same time setting an upper limit to the
#' overflow by means of a maximally allowed deviation \code{allowedDeviation}.
#'
#'@inheritParams itemValuesConstraint
#'@param allowedDeviation the maximum allowed deviation between the sum of the target values.
#'
#'@return An object of class \code{"constraint"}.
#'
#'@examples
#'# constraint that minimizes the maximum difference per test form value and a
#'#   target value of 0
#'maximinConstraint(nForms = 2, nItems = 10,
#'                  itemValues = rep(-2:2, 2),
#'                  allowedDeviation = 1)
#'
#'@export
maximinConstraint <- function(nForms, nItems, itemValues, allowedDeviation,
                              whichForms = seq_len(nForms), info_text = NULL,
                              itemIDs = names(itemValues)){

  # check allowed deviation
  if(length(allowedDeviation) > 1) stop("'allowedDeviation' should have length 1.")
  if(allowedDeviation <= 0) stop("'allowedDeviation' should be a positive value.")

  # choose info_text for info
  if(is.null(info_text)) info_text <- 'maximin'

  lowerBound <- makeFormConstraint(nForms, nItems, itemValues, realVar = -1,
                                   operator = ">=", targetValue = 0,
                                   whichForms, sense = "max", c_real = 1,
                                   info_text = paste0(info_text, "_lowerBound"),
                                   itemIDs = itemIDs)


  upperBound <- makeFormConstraint(nForms, nItems, itemValues, realVar = -1,
                                   operator = "<=", targetValue = allowedDeviation,
                                   whichForms, sense = NULL, c_real = 1,
                                   info_text = paste0(info_text, "_upperBound"),
                                   itemIDs = itemIDs)

  combine2Constraints(lowerBound, upperBound)
}


#' CappedMaximin Constraint.
#'
#' Create a maximin-constraints related to an item parameter/value. That is, the created
#' constraints can be used to maximize the minimal sum of the
#' item values (\code{itemValues}), while at the same time automatically setting
#' an ideal upper limit to the overflow.
#'
#'@inheritParams itemValuesConstraint
#'
#'@return An object of class \code{"constraint"}.
#'
#'@examples
#'# constraint that minimizes the maximum difference per test form value and a
#'#   target value of 0
#'cappedMaximinConstraint(nForms = 2, nItems = 10,
#'                  itemValues = rep(-2:2, 2))
#'
#'@export
cappedMaximinConstraint <- function(nForms, nItems, itemValues,
                                    whichForms = seq_len(nForms), info_text = NULL,
                                    itemIDs = names(itemValues)){


  # choose info_text for info
  if(is.null(info_text)) info_text <- 'cappedMaximin'

  lowerBound <- makeFormConstraint(nForms, nItems, itemValues, realVar = c(-1, 0),
                                   operator = ">=", targetValue = 0,
                                   whichForms, sense = "max", c_real = c(1, -1),
                                   info_text = paste0(info_text, "_lowerBound"),
                                   itemIDs = itemIDs)


  upperBound <- makeFormConstraint(nForms, nItems, itemValues, realVar = c(-1, 1),
                                   operator = "<=", targetValue = 0,
                                   whichForms, sense = NULL, c_real = c(1, -1),
                                   info_text = paste0(info_text, "_upperBound"),
                                   itemIDs = itemIDs)

  combine2Constraints(lowerBound, upperBound)
}




#' Max Constraint.
#'
#' Create max-constraints related to an item parameter/value. That is, the created
#' constraints can be used to maximize the sum of the
#' item values (\code{itemValues}) of the test form.
#' Note that this constraint can only be used when only one test form has to be assembled.
#'
#'@inheritParams itemValuesConstraint
#'
#'@return An object of class \code{"constraint"}.
#'
#'@examples
#'# constraint that maximizes the sum of the itemValues
#'maxConstraint(nItems = 10,itemValues = rep(-2:2, 2))
#'
#'@export
maxConstraint <- function(nItems, itemValues, info_text = NULL,
                          itemIDs = names(itemValues)){

  # choose info_text for info
  if(is.null(info_text)) info_text <- 'max'

  makeFormConstraint(nForms = 1, nItems, itemValues, realVar = -1,
                     operator = ">=", targetValue = 0, sense = "max",
                     c_real = 1, whichForms = 1,
                     info_text = info_text,
                     itemIDs = itemIDs)
}


#' Min Constraint.
#'
#' Create min-constraints related to an item parameter/value. That is, the created
#' constraints can be used to minimize the sum of the
#' item values (\code{itemValues}) of the test form.
#' Note that this constraint can only be used when only one test form has to be assembled.
#'
#'@inheritParams itemValuesConstraint
#'
#'@return An object of class \code{"constraint"}.
#'
#'@examples
#'# constraint that maximizes the sum of the itemValues
#'maxConstraint(nItems = 10,itemValues = rep(-2:2, 2))
#'
#'@export
minConstraint <- function(nItems, itemValues, info_text = NULL,
                          itemIDs = names(itemValues)){

  # choose info_text for info
  if(is.null(info_text)) info_text <- 'min'

  makeFormConstraint(nForms = 1, nItems, itemValues, realVar = -1,
                     operator = "<=", targetValue = 0, sense = "min",
                     c_real = 1, whichForms = 1,
                     info_text = info_text,
                     itemIDs = itemIDs)
}
