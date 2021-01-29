####
#############################################################################
#' Use a solver for a list of constraints.
#'
#' Use a mathematical programming solver to solve a list for constrains.
#'
#' Wrapper around the functions of different solvers (\code{gurobi::gurobi(),
#' lpSolve::lp(), ...} for a list of constraints set up via \code{eatATA}.
#' \code{Rglpk} is used per default.
#'
#' Additional arguments can be passed through
#' \code{...} and vary from solver to solver (see their respective help pages,
#' \code{\link[lpSolve]{lp}} or \code{\link[Rglpk]{Rglpk_solve_LP}}); for example
#' time limits can not be set for \code{lpSolve}.
#'
#'@param allConstraints List of constraints.
#'@param solver A character string indicating the solver to use.
#'@param timeLimit The maximal runtime in seconds.
#'@param formNames A character vector with names to give to the forms.
#'@param ... Additional arguments for the solver.
#'
#'@return A list with the following elements:
#'\describe{
#'   \item{\code{solution_found}}{Was a solution found?}
#'   \item{\code{solution}}{Numeric vector containing the found solution.}
#'   \item{\code{solution_status}}{Was the solution optimal?}
#' }
#'
#'
#'@examples
#' nForms <- 2
#' nItems <- 4
#'
#' # create constraits
#' target <- minimaxConstraint(nForms = nForms, c(1, 0.5, 1.5, 2),
#'                        targetValue = 2, itemIDs = 1:nItems)
#' noItemOverlap <- itemUsageConstraint(nForms, operator = "=", itemIDs = 1:nItems)
#' testLength <- itemsPerFormConstraint(nForms = nForms,
#'                            operator = "<=", targetValue = 2, itemIDs = 1:nItems)
#'
#' # use a solver
#' result <- useSolver(list(target, noItemOverlap, testLength),
#'   itemIDs = paste0("Item_", 1:4),
#'   solver = "GLPK")
#'
#'
#'
#'@export
useSolver <- function(allConstraints,
                      solver = c("GLPK", "lpSolve", "Gurobi", "Symphony"),
                      timeLimit = Inf,
                      formNames = NULL,
                      ...){

  # make sure solver is correct
  solver <- match.arg(solver)

  # combine all constraints
  allConstraints <- combineConstraints(allConstraints, message = FALSE)

  # extract info
  nItems <- attr(allConstraints, "nItems")
  nForms <- attr(allConstraints, "nForms")
  nBin <- nItems * nForms

  # check form names
  if(is.null(formNames)) formNames <- "form"
  if(length(formNames) == 1) formNames <- paste0(formNames, "_", seq_len(nForms))
  if(length(formNames) != nForms) stop("'formNames' should be a character string of length 1 or of length 'nForms'.")

  # call wrappers around solver
  if(solver == "GLPK") {
    out <- useGLPK(allConstraints, nBin, timeLimit, ...)
  } else if(solver == "lpSolve") {
    out <- useLpSolve(allConstraints, nBin, timeLimit, ...)
  } else if(solver == "Gurobi") {
    out <- useGurobi(allConstraints, nBin, timeLimit, ...)
  } else if(solver == "Symphony") {
    out <- useSymphony(allConstraints, nBin, timeLimit, ...)
  }
  if(out$solution_found) message("Optimal solution found.")
  else message('if'(is.null(out$solution_status),
                    "No optimal solution found.",
                    out$solution_status))

  # append infos (item matrix, nFOrms)
  out[["item_matrix"]] <-   as.data.frame(lapply(seq(nForms), function(formNr) {
    ind <- (formNr - 1)*nItems + 1:nItems
    out$solution[ind]
  }))

  names(out$item_matrix) <- formNames
  rownames(out$item_matrix) <- attr(allConstraints, "itemIDs")
  #out[["nForms"]] <- nForms
  out
}


### wrapper around Rglpk::Rglpk_solve_LP()  ------------------------------------
useGLPK <- function(allConstraints, nBin,
                    timeLimit, bounds = NULL, ...){

  # handle dots, make list
  dots <- as.list(substitute(...()))

  # Rglpk uses "==" rather then "="
  allConstraints$operators[allConstraints$operators == "="] <- "=="

  # create solver function
  solver_function <- Rglpk::Rglpk_solve_LP

  # create list with all the objects for Rglpk::Rglpk_solve_LP()
  objects_for_solver <- c(list(
    obj = c('if'(is.null(allConstraints$c_binary),
                 rep(0, nBin),
                 allConstraints$c_binary),
            allConstraints$c_real),
    mat = cbind(allConstraints$A_binary, allConstraints$A_real),
    dir = allConstraints$operators,
    rhs = allConstraints$d,
    bounds = bounds,
    types = c(rep("B", nBin), 'if'(is.null(allConstraints$c_real),
                                   NULL, rep("C", length(allConstraints$c_real)))),
    max = 'if'(is.null(attr(allConstraints, "sense")), FALSE, attr(allConstraints, "sense") == "max"),
    # Avoid warning when timeLimit == Inf
    control = list(
      canonicalize_status = FALSE,
      verbose = TRUE,
      tm_limit = 'if'(timeLimit == Inf, 0, timeLimit * 1000))),
    dots)

  # compute solution
  glpk_out <- do.call(solver_function, objects_for_solver)

  # object to return
  list(solution_found = glpk_out$status == 5,
       solution = glpk_out$solution,
       solution_status =
         switch(as.character(glpk_out$status),
                "1" = "The solution is undefined",
                "2" = "The solution is feasible, but may not be optimal",
                "3" = "The solution is infeasible",
                "4" = "No feasible solution exists",
                "5" = "The solution is optimal",
                "6" = "The solution is unbounded"))
}


### wrapper around lpSolve::lp() -----------------------------------------------
useLpSolve <- function(allConstraints, nBin,
                       timeLimit, ...){

  # handle dots, make list
  dots <- as.list(substitute(...()))

  # create solver function
  solver_function <- lpSolve::lp

    # create list with all the objects for lpSolve::lp()
  objects_for_solver <- c(list(
      direction = 'if'(is.null(attr(allConstraints, "sense")), "min", attr(allConstraints, "sense")),
      objective.in = c('if'(is.null(allConstraints$c_binary),
                            rep(0, nBin),
                            allConstraints$c_binary),
                       allConstraints$c_real),
      const.mat = as.matrix(cbind(allConstraints$A_binary, allConstraints$A_real)),
      transpose.constraints = TRUE,
      const.dir = allConstraints$operators,
      const.rhs = allConstraints$d,
      int.vec = seq_len(nBin),
      binary.vec = seq_len(nBin)),
    dots)

  # compute solution with time limit
  call <- substitute(do.call(solver_function, objects_for_solver))
  lpSolve_out <- #try(
    eval_call_with_time_limit(
      call,
      elapsed = timeLimit,
      on_time_out = list(status = "No solution due to time limit.",
                         solution = NULL))
    #)

#  if(inherits(lpSolve_out, "try-error")) {
#    msg <- attributes(lpSolve_out)$condition$message
#    if(msg == "reached elapsed time limit") {
#      lpSolve_out <- list(status = "No solution due to time limit.",
#                       solution = NULL)
#      warning(msg)
#    }
#  }

  # object to return
  list(solution_found = lpSolve_out$status == 0,
       solution = lpSolve_out$solution,
       solution_status = lpSolve_out$status)
}



### wrapper around gurobi::gurobi() --------------------------------------------
useGurobi <- function(allConstraints, nBin,
                      timeLimit, ...){

  # handle dots, make list
  dots <- as.list(substitute(...()))

  # create solver function
  solver_function <- substitute(gurobi::gurobi)

  if(timeLimit == Inf) timeLimit <- 9999

  # create list with all the objects for gurobi::gurobi()
  objects_for_solver <- list(model = c(
      list(A = as.matrix(cbind(allConstraints$A_binary, allConstraints$A_real)),
           rhs = allConstraints$d,
           sense = allConstraints$operators,
           obj = c('if'(is.null(allConstraints$c_binary),
                        rep(0, nBin),
                        allConstraints$c_binary),
                   allConstraints$c_real),
           modelsense = attr(allConstraints, "sense"),
           vtype = c(rep("B", nBin), 'if'(is.null(allConstraints$c_real),
                                          NULL, rep("C", length(allConstraints$c_real))))),
      dots),
    params = c(TimeLimit = timeLimit, dots))

  # compute solution
  gurobi_out <- 'if'(requireNamespace("gurobi", quietly = TRUE),
                   do.call(eval(solver_function), objects_for_solver),
                   {message("No solution, the 'gurobi'-package is not installed");
                   NULL})

  # object to return
  list(solution_found = gurobi_out$status %in% c("OPTIMAL"),
       solution = gurobi_out$x,
       solution_status = gurobi_out$status)

}


### wrapper around Rsymphony::Rsymphony_solve_LP() --------------------------------------------
useSymphony <- function(allConstraints, nBin,
                        timeLimit, bounds = NULL, ...){

  # handle dots, make list
  dots <- as.list(substitute(...()))

  # Symphony uses "==" rather then "="
  allConstraints$operators[allConstraints$operators == "="] <- "=="

  if(timeLimit == Inf) timeLimit <- -1

  # create solver function
  solver_function <- Rsymphony::Rsymphony_solve_LP

  # create list with all the objects for Rsymphony::Rsymphony_solve_LP()
  objects_for_solver <- c(list(
    obj = c('if'(is.null(allConstraints$c_binary),
                 rep(0, nBin),
                 allConstraints$c_binary),
            allConstraints$c_real),
    mat = cbind(allConstraints$A_binary, allConstraints$A_real),
    dir = allConstraints$operators,
    rhs = allConstraints$d,
    bounds = bounds,
    types = c(rep("B", nBin), 'if'(is.null(allConstraints$c_real),
                                   NULL, rep("C", length(allConstraints$c_real)))),
    max = attr(allConstraints, "sense") == "max",
    time_limit = timeLimit,
    verbosity = -2))

  # compute solution
  symphony_out <- do.call(solver_function, objects_for_solver)

  # object to return
  list(solution_found = symphony_out$status == 0,
       solution = symphony_out$solution,
       solution_status = "not yet researched, tbd")
}

# function that evaluates a call with a time limit
eval_call_with_time_limit <- function(
  call, cpu = Inf, elapsed = Inf,
  transient = TRUE,
  envir = parent.frame(),
  enclos = if(is.list(envir) || is.pairlist(envir)) parent.frame else baseenv(),
  on_time_out = NULL,
  ...){

  setTimeLimit(cpu, elapsed, transient)
  on.exit(setTimeLimit(cpu = Inf,
                       elapsed = Inf,
                       transient = FALSE))

  tryCatch({
    eval(call, envir = envir, enclos = enclos)
  },
  error = function(e) {
    msg <- e$message
    if (regexpr(gettext("reached elapsed time limit", domain="R"),
                msg) != -1L & !is.null(on_time_out)) {
      if(is.function(on_time_out)) return(on_time_out(...))
        return(on_time_out)
      } else {
        stop(msg, call. = FALSE)
      }
  })
}


