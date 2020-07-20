
test_that("Prepare constraints", {
  usage <- itemUsageConstraint(nForms = 2, nItems = 10, operator = "=", targetValue = 1)
  perForm <- itemsPerFormConstraint(nForms = 2, nItems = 10, operator = "=", targetValue = 5)
  target <- itemTargetConstraint(nForms = 2, nItems = 10, itemValues = 1:10, targetValue = 5)

  expect_silent(out <- prepareConstraints(list(usage, perForm, target), nForms = 2, nItems = 10))

  expect_equal(names(out), c("A", "rhs", "sense", "obj", "modelsense", "vtype"))
  expect_equal(out$modelsense, "min")
  expect_equal(dim(out$A), c(16, 21))

})


test_that("Prepare constraints error", {
  usage <- itemUsageConstraint(nForms = 2, nItems = 10, operator = "=", targetValue = 1)
  perForm <- itemsPerFormConstraint(nForms = 2, nItems = 10, operator = "=", targetValue = 5)
  target <- itemTargetConstraint(nForms = 2, nItems = 10, itemValues = 1:10, targetValue = 5)

  expect_error(out <- prepareConstraints(list(usage, perForm, target, mtcars), nForms = 2, nItems = 10))
})
