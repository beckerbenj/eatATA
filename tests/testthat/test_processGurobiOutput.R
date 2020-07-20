

items_small <- data.frame(ID = 1:10)
#usage <- itemUsageConstraint(nForms = 2, nItems = 10, operator = "=", targetValue = 1)
#perForm <- itemsPerFormConstraint(nForms = 2, nItems = 10, operator = "=", targetValue = 5)
#target <- itemTargetConstraint(nForms = 2, nItems = 10, itemValues = 1:10, targetValue = 5)
#g_mod <- prepareConstraints(list(usage, perForm, target), nForms = 2, nItems = 10)
#out <- gurobi::gurobi(g_mod)
#saveRDS(out, "tests/testthat/helper_gurobi_out.RDS")

#out <- readRDS("tests/testthat/helper_gurobi_out.RDS")
out <- readRDS("helper_gurobi_out.RDS")

test_that("process gurobi output", {
  l <- processGurobiOutput(out, items = items_small, nForms = 2, output = "list")
  expect_equal(length(l), 2)
  expect_equal(dim(l[[1]]), c(5, 3))

  df <- processGurobiOutput(out, items = items_small, nForms = 2, output = "data.frame")
  expect_equal(dim(df), c(10, 3))
  expect_equal(df$form_1, c(0, 1, 1, 1, 0, 0, 0, 0, 1, 1))
})



