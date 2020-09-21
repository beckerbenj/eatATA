
items <- data.frame(ID = 1:10,
                    itemValues = c(-4, -4, -2, -2, -1, -1, 20, 20, 0, 0))

usage <- itemUsageConstraint(nForms = 2, nItems = 10, operator = "=", targetValue = 1)
perForm <- itemsPerFormConstraint(nForms = 2, nItems = 10, operator = "=", targetValue = 5)
target <- itemTargetConstraint(nForms = 2, nItems = 10,
                               itemValues = items$itemValues,
                               targetValue = 0)

test_that("Solve problem using lpsolve", {
  out <- useSolver(allConstraints = list(usage, perForm, target),
            nForms = 2, nItems = 10, solver = "lpSolve")

  sol <- out$solution$solution

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
  out <- useSolver(allConstraints = list(usage, perForm, target),
                   nForms = 2, nItems = 10, solver = "GLPK")

  sol <- out$solution$solution

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

test_that("Solve problem using gurobi", {
  outp <- capture_output(out <- useSolver(allConstraints = list(usage, perForm, target),
                   nForms = 2, nItems = 10, solver = "Gurobi"))

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


