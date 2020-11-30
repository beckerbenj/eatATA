

items <- data.frame(ID = paste0("item_", 1:10),
                    itemValues = c(-4, -4, -2, -2, -1, -1, 20, 20, 0, 0),
                    stringsAsFactors = FALSE)

usage <- itemUsageConstraint(nForms = 2, nItems = 10, operator = "=", targetValue = 1)
perForm <- itemsPerFormConstraint(nForms = 2, nItems = 10, operator = "=", targetValue = 5)
target <- itemTargetConstraint(nForms = 2, nItems = 10,
                               itemValues = items$itemValues,
                               targetValue = 0)

suppressMessages(sol <- useSolver(allConstraints = list(usage, perForm, target),
                 nForms = 2, itemIDs = items$ID, solver = "lpSolve"))

suppressMessages(sol_empty <- useSolver(allConstraints = list(target),
                                  nForms = 2, itemIDs = items$ID, solver = "lpSolve"))


test_that("append solution", {
  out <- appendSolution(sol, items = items, idCol = "ID")

  expect_equal(dim(out), c(10, 4))
  expect_equal(names(out), c(names(items), paste0("block_", 1:2)))
  expect_equal(rownames(out), paste0("item_", 1:10))
})


test_that("errors", {
  items2 <- items
  items2[1, "ID"] <- "item_15"
  expect_error(appendSolution(sol_empty, items = items2, idCol = "ID"),
               "'items' and the solution in 'solverOut' have different sets of itemIDs.")

})
