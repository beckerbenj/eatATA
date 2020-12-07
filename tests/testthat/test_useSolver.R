
items <- data.frame(ID = paste0("item_", 1:10),
                    itemValues = c(-4, -4, -2, -2, -1, -1, 20, 20, 0, 0),
                    stringsAsFactors = FALSE)

usage <- itemUsageConstraint(nForms = 2, nItems = 10, operator = "=", targetValue = 1)
perForm <- itemsPerFormConstraint(nForms = 2, nItems = 10, operator = "=", targetValue = 5)
target <- itemTargetConstraint(nForms = 2, nItems = 10,
                               itemValues = items$itemValues,
                               targetValue = 0)

test_that("Solve problem using lpsolve", {
  expect_message(out <- useSolver(allConstraints = list(usage, perForm, target),
            nForms = 2, itemIDs = items$ID, solver = "lpSolve"),
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
                   nForms = 2, itemIDs = items$ID, solver = "GLPK", verbose = FALSE),
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
                                  nForms = 2, itemIDs = items$ID, solver = "GLPK"))
})

requireNamespace("gurobi", quietly = TRUE)

if("gurobi" %in% rownames(installed.packages())){
  test_that("Solve problem using gurobi", {
    outp <- capture_output(out <- useSolver(allConstraints = list(usage, perForm, target),
                                            nForms = 2, itemIDs = items$ID, solver = "Gurobi"))

    sol <- out$solution$x
    objval <- out$solution$objval
    processGurobiOutput(out$solution, items = items, nForms = 2)

    expect_equal(sum(sol[1:10]), 5)
    expect_equal(sum(sol[11:20]), 5)
    for(i in 1:10) {
      expect_equal(sum(sol[i], sol[i+10]), 1)
    }
    for(i in seq(1, 19, by = 2)) {
      expect_equal(sum(sol[i], sol[i+1]), 1)
    }
    expect_equal(objval, 13)
  })
}

test_that("Output format", {
  expect_message(out <- useSolver(allConstraints = list(usage, perForm, target),
                                  nForms = 2, itemIDs = items$ID, solver = "GLPK", verbose = FALSE),
                 "Optimal solution found.")

  expect_equal(names(out), c("solution_found", "solution", "solution_status", "item_matrix"))
  expect_equal(rownames(out$item_matrix), paste0("item_", 1:10))
})

nItems <- 100
nForms <- 2
set.seed(144)
items <- data.frame(ID = paste0("item_", 1:nItems),
                    itemValues = rnorm(nItems), stringsAsFactors = FALSE)
#save(items, file = "tests/testthat/helper_glpk_timeLimit.RData")
load("helper_glpk_timeLimit.RData")

usage <- itemUsageConstraint(nForms = nForms, nItems = nItems, operator = "=", targetValue = 1)
target <- itemTargetConstraint(nForms = nForms, nItems = nItems,
                               itemValues = items$itemValues,
                               targetValue = 0)
test_that("Solve problem with time limit using glpk", {
  expect_message(out <- useSolver(allConstraints = list(usage, target),
                                  nForms = nForms, itemIDs = items$ID, solver = "GLPK", timeLimit = 0.1, verbose = FALSE),
                 "The solution is feasible, but may not be optimal.")
  expect_false(out$solution_found)
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
  expect_equal(eval_call_with_time_limit(call, elapsed = .1, on_time_out = mean, x = c(1:3)),
               2)
  expect_error(eval_call_with_time_limit(call, elapsed = .1), "reached elapsed time limit")
  expect_equal(eval_call_with_time_limit(call, elapsed = .1, on_time_out = "OK"), "OK")

})
