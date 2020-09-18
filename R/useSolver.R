####
#############################################################################
#' Use a solver for a list of constraints.
#'
#' Wrapper around the functions of different solvers (\code{gurobi::gurobi(),
#' lpSolve::lp(), ...} for a list of constraints set up via \code{eatATA} as input to the \code{gurobi} function.
#'
#'@param allConstraints List of constraints.
#'@param nForms Number of forms to be created.
#'@param nItems Number of items in the item pool.
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
#'   nForms = nForms, nItems = nItems, solver = "GLPK")
#'
#' # run the solver again
#' with(result, do.call(solver_function, objects_for_solver))
#'
#'
#'
#'@export
useSolver <- function(allConstraints, nForms, nItems,
                      solver = c("GLPK", "lpSolve", "Gurobi"),
                      timeLimit = Inf,
                      modelSense = c("min", "max"),
                      ...){

  # make sure solver is correct
  solver <- match.arg(solver)
  modelSense <- match.arg(modelSense)

  # check constraints
  if(!is.list(allConstraints)) stop("allConstraints needs to be a list.")
  if(!all(sapply(allConstraints, function(x) "dgCMatrix" %in% class(x)))) stop("All elements in allConstraints need to be matrices.")

  # combine all constraints
  Ad <- do.call(rbind, allConstraints)

  # get values for MILP
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
    tm_limit = 'if'(timeLimit == Inf, 0, timeLimit * 1000)),
    dots)

  # compute solution
  solution <- do.call(solver_function, objects_for_solver)

  # object to return
  out <- list(solution = solution,
              solver_function = solver_function,
              objects_for_solver = objects_for_solver)

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
  solution <- eval_call_with_time_limit(call, elapsed = timeLimit, ...)

  # object to return
  out <- list(solution = solution,
              solver_function = solver_function,
              objects_for_solver = objects_for_solver)
}



### wrapper around gurobi::gurobi() --------------------------------------------
useGurobi <- function(A, direction, d, c, modelSense, nBin, nVar,
                      timeLimit, ...){

  # handle dots, make list
  dots <- as.list(substitute(...()))

  # create solver function
  solver_function <- substitute(gurobi::gurobi)

  # create list with all the objects for Rglpk::Rglpk_solve_LP()
  objects_for_solver <- list(MILP = c(
      list(A = A,
           rhs = d,
           sense = direction,
           obj = c,
           modelsense = modelSense,
           vtype = c(rep("B", nBin), "C")),
      dots),
    params = c(TimeLimit = timeLimit, dots))

  # compute solution
  solution <- 'if'(requireNamespace("gurobi", quietly = TRUE),
                   do.call(eval(solver_function), objects_for_solver),
                   {message("No solution, the 'gurobi'-package is not installed");
                   NULL})

  # object to return
  out <- list(solution = solution,
              solver_function = solver_function,
              objects_for_solver = objects_for_solver)

}


# function that evaluates a call with a time limit
eval_call_with_time_limit <- function(call, cpu = Inf, elapsed = Inf,
                                 transient = TRUE,
                                 envir = parent.frame(), ...){
  try({
    setTimeLimit(cpu, elapsed, transient)
    eval(call, envir = envir, ...)})
}

