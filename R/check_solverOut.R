# validate useSolver outputs
check_solverOut <- function(solverOut) {
  if(!is.list(solverOut)) stop("'solverOut' must be a list.")
  if(length(solverOut) != 4) stop("'solverOut' must be of length 4.")
  if(!identical(names(solverOut), c("solution_found", "solution", "solution_status", "item_matrix"))) stop("'solverOut' must contain the elements 'solution_found', 'solution', 'solution_status' and 'item_matrix'.")
  if(!identical(names(solverOut), c("solution_found", "solution", "solution_status", "item_matrix"))) stop("'solverOut' must be of length 4.")
  if(!is.logical(solverOut$solution_found) && length(solverOut$solution_found)) stop("'solverOut$solution_found' must be logical of length 1.")
  if(!(is.character(solverOut$solution_status) || is.numeric(solverOut$solution_status)) || length(solverOut$solution_status) != 1) stop("'solverOut$solution_status' must be character or numeric of length 1.")
  if(!is.data.frame(solverOut$item_matrix)) stop("'solverOut$item_matrix' must be data.frame.")
  return()
}

check_solution_true <- function(solverOut) {
  if(!solverOut$solution_found && all(solverOut$solution == 0)) stop("'solverOut' does not contain a feasible solution.")
  return()
}
