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
#'@param nForms Number of forms to be created.
#'@param itemIDs Character vector of item IDs.
#'@param solver A character string indicating the solver to use.
#'@param timeLimit The maximal runtime in seconds.
#'@param modelSense A character string indicating whether to minimize or
#'  maximize the objective function.
#'@param ... Additional arguments for the solver.
#'
#'@return A list with the following elements:
#'\describe{
#'   \item{\code{solution}}{The object returned by the solver.}
#'   \item{\code{solver_function}}{The solver function that was called, and can be called with the \code{objects_for_solver}.}
#'   \item{\code{objects_for_solver}}{A list with the objects that are used in the call.}
#' }
#'
#'
#'@examples
#' nForms <- 2
#' nItems <- 4
#'
#' # create constraits
#' target <- itemTargetConstraint(nForms = nForms, nItems = nItems,
#'   c(1, 0.5, 1.5, 2), targetValue = 2)
#' noItemOverlap <- itemUsageConstraint(nForms, nItems = nItems, operator = "=")
#' testLength <- itemsPerFormConstraint(nForms = nForms, nItems = nItems,
#'   operator = "<=", 2)
#'
#' # use a solver
#' result <- useSolver(list(target, noItemOverlap, testLength),
#'   nForms = nForms, itemIDs = paste0("Item_", 1:4),
#'   solver = "GLPK")
#'
#'
#'
#'@export
useSolver <- function(allConstraints, nForms, itemIDs,
                      solver = c("GLPK", "lpSolve", "Gurobi"),
                      timeLimit = Inf,
                      modelSense = c("min", "max"),
                      ...){

  # make sure solver is correct
  solver <- match.arg(solver)
  modelSense <- match.arg(modelSense)

  # check inputs
  check_single_numeric(nForms)
  if(!is.character(itemIDs) && !is.numeric(itemIDs)) stop("'itemIDs' needs to be a numeric or character vector.")
  if(!is.character(solver) || length(solver) != 1 || !solver %in% c("GLPK", "lpSolve", "Gurobi")) stop("'solver' needs to be exactly one of 'GLPK', 'lpSolve', or 'Gurobi'.")

  # check constraints
  if(!is.list(allConstraints)) stop("allConstraints needs to be a list.")
  if(!all(sapply(allConstraints, function(x) "dgCMatrix" %in% class(x)))) stop("All elements in allConstraints need to be matrices.")

  # combine all constraints
  Ad <- do.call(rbind, allConstraints)

  # get values for MILP
  nItems <- length(itemIDs)
  nBin <- nItems*nForms         # number of binary MILP variables
  nVar <- nBin + 1              # number of MILP variables
  A <- as.matrix(Ad[ , 1:nVar])     # matrix with left-hand side of constraints
  d <- as.vector(Ad[ ,(nVar + 2)])  # vector with right-hand side of constraints
  c <- c(rep(0, nBin), 1)       # vector with the weights of the constraints


  # directions for the constraints
  direction <- as.vector(Ad[ ,(nVar + 1)])
  direction[which(direction==-1)] <- "<="
  direction[which(direction==0)] <- "="
  direction[which(direction==1)] <- ">="

  # call wrappers around solver
  if(solver == "GLPK") {
    out <- useGLPK(A, direction, d, c, modelSense, nBin, nVar, timeLimit, ...)
  } else if(solver == "lpSolve") {
    out <- useLpSolve(A, direction, d, c, modelSense, nBin, nVar, timeLimit, ...)
  } else if(solver == "Gurobi") {
    out <- useGurobi(A, direction, d, c, modelSense, nBin, nVar, timeLimit, ...)
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
  names(out$item_matrix) <- paste0("block_", seq(nForms))
  rownames(out$item_matrix) <- itemIDs
  #out[["nForms"]] <- nForms
  out
}


### wrapper around Rglpk::Rglpk_solve_LP()  ------------------------------------
useGLPK <- function(A, direction, d, c, modelSense, nBin, nVar,
                    timeLimit, bounds = NULL, ...){

  # handle dots, make list
  dots <- as.list(substitute(...()))

  # Rglpk uses "==" rather then "="
  direction[direction == "="] <- "=="

  # create solver function
  solver_function <- Rglpk::Rglpk_solve_LP

  # create list with all the objects for Rglpk::Rglpk_solve_LP()
  objects_for_solver <- c(list(
    obj = c,
    mat = A,
    dir = direction,
    rhs = d,
    bounds = bounds,
    types = c(rep("B", nBin), "C"),
    max = modelSense == "max",
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
useLpSolve <- function(A, direction, d, c, modelSense, nBin, nVar,
                       timeLimit, ...){

  # handle dots, make list
  dots <- as.list(substitute(...()))

  # create solver function
  solver_function <- lpSolve::lp

    # create list with all the objects for lpSolve::lp()
  objects_for_solver <- c(list(
      direction = modelSense,
      objective.in = c,
      const.mat = A,
      transpose.constraints = TRUE,
      const.dir = direction,
      const.rhs = d,
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
useGurobi <- function(A, direction, d, c, modelSense, nBin, nVar,
                      timeLimit, ...){

  # handle dots, make list
  dots <- as.list(substitute(...()))

  # create solver function
  solver_function <- substitute(gurobi::gurobi)

  if(timeLimit == Inf) timeLimit <- 9999

  # create list with all the objects for Rglpk::Rglpk_solve_LP()
  objects_for_solver <- list(model = c(
      list(A = A,
           rhs = d,
           sense = direction,
           obj = c,
           modelsense = modelSense,
           vtype = c(rep("B", nBin), "C")),
      dots),
    params = c(TimeLimit = timeLimit, dots))

  # compute solution
  gurobi_out <- 'if'(requireNamespace("gurobi", quietly = TRUE),
                   do.call(eval(solver_function), objects_for_solver),
                   {message("No solution, the 'gurobi'-package is not installed");
                   NULL})

  # object to return
  list(solution_found = gurobi_out$status %in% c("OPTIMAL"),
       solution = gurobi_out$x)

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


