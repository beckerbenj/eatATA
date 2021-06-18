
items <- data.frame(ID = paste0("item_", 1:10),
                    itemValues = c(-4, -4, -2, -2, -1, -1, 20, 20, 0, 0),
                    itemIDs = paste0("it", 1:10),
                    stringsAsFactors = FALSE)

usage <- itemUsageConstraint(nForms = 2, operator = "=", targetValue = 1, itemIDs = items$itemIDs)
perForm <- itemsPerFormConstraint(nForms = 2, operator = "=", targetValue = 5, itemIDs = items$itemIDs)
target <- minimaxObjective(nForms = 2, itemValues = items$itemValues,
                               targetValue = 0, itemIDs = items$itemIDs)

test_that("Solve problem using lpsolve", {
  expect_message(out <- useSolver(allConstraints = list(usage, perForm, target),
                                  solver = "lpSolve"),
            "Optimal solution found.")
  expect_true(out$solution_found)
  sol <- out$solution

  expect_equal(sum(sol[1:10]), 5)
  expect_equal(sum(sol[11:20]), 5)
  for(i in 1:10) {
    expect_equal(sum(sol[i], sol[i+10]), 1)
  }
  for(i in seq(1, 19, by = 2)) {
    expect_equal(sum(sol[i], sol[i+1]), 1)
  }
  expect_equal(sol[21], 13)
})

test_that("Solve problem using glpk", {
  expect_message(out <- useSolver(allConstraints = list(usage, perForm, target),
                   solver = "GLPK", verbose = FALSE),
                  "Optimal solution found.")

  expect_true(out$solution_found)
  sol <- out$solution

  expect_equal(sum(sol[1:10]), 5)
  expect_equal(sum(sol[11:20]), 5)
  for(i in 1:10) {
    expect_equal(sum(sol[i], sol[i+10]), 1)
  }
  for(i in seq(1, 19, by = 2)) {
    expect_equal(sum(sol[i], sol[i+1]), 1)
  }
  expect_equal(sol[21], 13)
  expect_output(out <- useSolver(allConstraints = list(usage, perForm, target),
                                  solver = "GLPK"))
})

requireNamespace("gurobi", quietly = TRUE)
if("gurobi" %in% rownames(installed.packages())){
  test_that("Solve problem using gurobi", {
    outp <- capture_output(out <- useSolver(allConstraints = list(usage, perForm, target),
                                            solver = "Gurobi"))

    sol <- out$solution

    expect_equal(sum(sol[1:10]), 5)
    expect_equal(sum(sol[11:20]), 5)
    for(i in 1:10) {
      expect_equal(sum(sol[i], sol[i+10]), 1)
    }
    for(i in seq(1, 19, by = 2)) {
      expect_equal(sum(sol[i], sol[i+1]), 1)
    }
    expect_equal(sol[21], 13)
  })
}

requireNamespace("Rsymphony", quietly = TRUE)
if("Rsymphony" %in% rownames(installed.packages())){
test_that("Solve problem using Symphony", {
  expect_message(out <- useSolver(allConstraints = list(usage, perForm, target),
                                  nForms = 2, itemIDs = items$ID, solver = "Symphony", verbose = FALSE),
                 "Optimal solution found.")

  expect_true(out$solution_found)
  sol <- out$solution

  expect_equal(sum(sol[1:10]), 5)
  expect_equal(sum(sol[11:20]), 5)
  for(i in 1:10) {
    expect_equal(sum(sol[i], sol[i+10]), 1)
  }
  for(i in seq(1, 19, by = 2)) {
    expect_equal(sum(sol[i], sol[i+1]), 1)
  }
  expect_equal(sol[21], 13)
})
}


# -----------------------------------------------------------------------------------------------------------

test_that("Output format", {
  expect_message(out <- useSolver(allConstraints = list(usage, perForm, target),
                                  solver = "GLPK", verbose = FALSE),
                 "Optimal solution found.")

  nItems <- attr(usage, "nItems")

  expect_equal(names(out), c("solution_found", "solution", "solution_status", "item_matrix"))
  #expect_equal(rownames(out$item_matrix), sprintf(paste("it%0", nchar(nItems), "d", sep=''), seq_len(nItems)))
  expect_equal(rownames(out$item_matrix), paste0("it", seq_len(nItems)))
})

test_that("Output format infeasible solution", {
  inf_constr1 <- itemValuesConstraint(nForms = 2, itemValues = c(1, rep(0, nrow(items)-1)),
                                     operator = "=", targetValue = 1, itemIDs = items$itemIDs)
  expect_message(out <- useSolver(allConstraints = list(usage, perForm, target, inf_constr1),
                                  solver = "GLPK", verbose = FALSE),
                 "The solution is undefined")

  expect_equal(names(out), c("solution_found", "solution", "solution_status", "item_matrix"))
  #expect_equal(rownames(out$item_matrix), sprintf(paste("it%0", nchar(nItems), "d", sep=''), seq_len(nItems)))
  nItems <- attr(usage, "nItems")
  expect_equal(rownames(out$item_matrix), paste0("it", seq_len(nItems)))
  expect_false(out$solution_found)
  expect_equal(out$solution, rep(0, (nItems*2)+1))
})

nItems <- 100
nForms <- 2
set.seed(144)
items <- data.frame(ID = paste0("item_", 1:nItems),
                    itemValues = rnorm(nItems), stringsAsFactors = FALSE)
#save(items, file = "tests/testthat/helper_glpk_timeLimit.RData")
#load("helper_glpk_timeLimit.RData")

usage <- itemUsageConstraint(nForms = nForms, nItems = nItems, operator = "=", targetValue = 1, itemIDs = items$ID)
target <- minimaxObjective(nForms = nForms, itemValues = with(items, structure(itemValues, names = ID)),
                               targetValue = 0, itemIDs = items$ID)

# run this test only for development versions, as frequently GLPK does not find a feasible solution that quickly on CRAN
if (length(strsplit(packageDescription("eatATA")$Version, "\\.")[[1]]) > 3) {
  test_that("Solve problem with time limit using glpk (suboptimal solution", {
    expect_message(out <- useSolver(allConstraints = list(usage, target),
                                    solver = "GLPK", timeLimit = 0.1, verbose = FALSE),
                   "The solution is feasible, but may not be optimal.")
    expect_false(out$solution_found)
  })
}

test_that("useSolver returns errors", {
  expect_error(useSolver(allConstraints = list(usage, target),
                         solver = "G", timeLimit = 0.1, verbose = FALSE))
  expect_error(useSolver(allConstraints = list(usage, target),
                         solver = "GL", timeLimit = 0.1, verbose = FALSE,
                         formNames = c("to", "many", "names")), "'formNames' should be a character string of length 1 or of length 'nForms'.")
})







#test_that("Solve problem with time limit using lpsolve", {
#  expect_error(out <- useSolver(allConstraints = list(usage, target),
#                                nForms = nForms, itemIDs = items$ID, solver = "lpSolve", timeLimit = 0.1),
#               "reached elapsed time limit")
#})



fun <- function(x){
  for(i in seq_len(x)){
    Sys.sleep(.5)
    cat(i)
  }
}
call <- substitute(fun(6))

test_that("eval_with_time_limit works", {
  expect_equal(eval_call_with_time_limit(call, elapsed = .5, on_time_out = mean, x = c(1:3)),
               2)
  expect_error(out <- eval_call_with_time_limit(call, elapsed = .5), "reached elapsed time limit")
  expect_equal(eval_call_with_time_limit(call, elapsed = .5, on_time_out = "OK"), "OK")
})

