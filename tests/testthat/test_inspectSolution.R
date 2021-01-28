

items <- data.frame(ID = paste0("item_", 1:10),
                    itemValues = c(-4, -4, -2, -2, -1, -1, 20, 20, 0, 0),
                    format = c(rep("mc", 5), rep("open", 5)),
                    stringsAsFactors = FALSE)

usage <- itemUsageConstraint(nForms = 2, nItems = 10, operator = "=",
                             targetValue = 1, itemIDs = items$ID)
perForm <- itemsPerFormConstraint(nForms = 2, nItems = 10, operator = "=",
                                  targetValue = 5, itemIDs = items$ID)
target <- minimaxConstraint(nForms = 2, itemValues = items$itemValues,
                               targetValue = 0, itemIDs = items$ID)

suppressMessages(sol <- useSolver(allConstraints = list(usage, perForm, target),
                 solver = "lpSolve", formNames = "block"))

suppressMessages(sol_empty <- useSolver(allConstraints = list(target),
                                  solver = "lpSolve"))


test_that("inspect solution", {
  out <- inspectSolution(sol, items = items, idCol = "ID")

  expect_equal(length(out), 2)
  expect_equal(names(out), paste0("block_", 1:2))
  expect_equal(out[[1]]$ID, c(paste0("item_", c(1, 3, 5, 8, 10)), NA))
  expect_equal(dim(out[[1]]), c(6, 3))
})


test_that("inspect solution complete items data.frame", {
  out <- inspectSolution(sol, items = items, idCol = "ID", colNames = names(items), colSums = FALSE)

  expect_equal(length(out), 2)
  expect_equal(names(out), paste0("block_", 1:2))
  expect_equal(out[[1]]$ID, paste0("item_", c(1, 3, 5, 8, 10)))
  expect_equal(dim(out[[1]]), c(5, 3))
})

test_that("inspect solution for empty test forms", {
  out <- inspectSolution(sol_empty, items = items, idCol = "ID", colNames = names(items), colSums = FALSE)

  expect_equal(length(out), 2)
  expect_equal(names(out), paste0("form_", 1:2))
  expect_equal(nrow(out[[1]]), 0)
})

test_that("errors", {
  expect_error(inspectSolution(sol_empty, items = items, idCol = "ID2", colNames = names(items)),
               "'idCol' is not a column in 'items'.")
  expect_error(inspectSolution(sol_empty, items = mtcars, idCol = "ID", colNames = names(items)),
               "The following 'colNames' are not columns in 'items': ID, itemValues")
  items2 <- items
  items2[1, "ID"] <- "item_15"
  expect_error(inspectSolution(sol_empty, items = items2, idCol = "ID", colNames = names(items)),
               "'items' and the solution in 'solverOut' have different sets of itemIDs.")

})
