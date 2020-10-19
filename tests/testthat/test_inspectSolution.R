

items <- data.frame(ID = 1:10,
                    itemValues = c(-4, -4, -2, -2, -1, -1, 20, 20, 0, 0))

usage <- itemUsageConstraint(nForms = 2, nItems = 10, operator = "=", targetValue = 1)
perForm <- itemsPerFormConstraint(nForms = 2, nItems = 10, operator = "=", targetValue = 5)
target <- itemTargetConstraint(nForms = 2, nItems = 10,
                               itemValues = items$itemValues,
                               targetValue = 0)

suppressMessages(sol <- useSolver(allConstraints = list(usage, perForm, target),
                 nForms = 2, nItems = 10, solver = "lpSolve"))

suppressMessages(sol_empty <- useSolver(allConstraints = list(target),
                                  nForms = 2, nItems = 10, solver = "lpSolve"))


test_that("inspect solution", {
  out <- inspectSolution(sol, items = items, colNames = "itemValues")

  expect_equal(length(out), 2)
  expect_equal(names(out), paste0("block_", 1:2))
  expect_equal(rownames(out[[1]]), c(paste0("Item ", 1:5), "Sum"))
  expect_equal(dim(out[[1]]), c(6, 1))
})


test_that("inspect solution complete items data.frame", {
  out <- inspectSolution(sol, items = items, colNames = names(items), colSums = FALSE)

  expect_equal(length(out), 2)
  expect_equal(names(out), paste0("block_", 1:2))
  expect_equal(rownames(out[[1]]), paste0("Item ", 1:5))
  expect_equal(dim(out[[1]]), c(5, 2))
})

test_that("inspect solution for empty test forms", {
  out <- inspectSolution(sol_empty, items = items, colNames = names(items), colSums = FALSE)

  expect_equal(length(out), 2)
  expect_equal(names(out), paste0("block_", 1:2))
  expect_equal(nrow(out[[1]]), 0)
})
