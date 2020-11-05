
items <- data.frame(ID = paste0("item_", 1:10),
                    itemValues = c(-4, -4, -2, -2, -1, -1, 20, 20, 0, 0))

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
                   nForms = 2, itemIDs = items$ID, solver = "GLPK"),
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
                                  nForms = 2, itemIDs = items$ID, solver = "GLPK"),
                 "Optimal solution found.")

  expect_equal(names(out), c("solution_found", "solution", "item_matrix"))
  expect_equal(rownames(out$item_matrix), paste0("item_", 1:10))
})

