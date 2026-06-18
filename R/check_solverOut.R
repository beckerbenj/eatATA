# validate useSolver outputs
check_solverOut <- function(solverOut) {
  checkmate::assert_list(solverOut, len = 4, )
  checkmate::assert_subset(names(solverOut), choices = c("solution_found", "solution", "solution_status", "item_matrix"))
  if(!is.logical(solverOut$solution_found) && length(solverOut$solution_found)) stop("'solverOut$solution_found' must be logical of length 1.")
  if(!(is.character(solverOut$solution_status) || is.numeric(solverOut$solution_status)) || length(solverOut$solution_status) != 1) stop("'solverOut$solution_status' must be character or numeric of length 1.")
  if(!is.data.frame(solverOut$item_matrix)) stop("'solverOut$item_matrix' must be data.frame.")
  return()
}

check_solution_true <- function(solverOut) {
  if(!solverOut$solution_found && all(solverOut$solution == 0)) stop("'solverOut' does not contain a feasible solution.")
  return()
}
