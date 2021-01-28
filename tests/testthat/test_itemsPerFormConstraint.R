

test_that("Items per Form Constraint works", {
  out <- itemsPerFormConstraint(2, operator = "=", targetValue = 2, itemIDs = 1:4)
  expect_equal(out$A_binary[1, ], c(1, 1, 1, 1, 0, 0, 0, 0))
  expect_equal(out$A_binary[2, ], c(0, 0, 0, 0, 1, 1, 1, 1))

  warn <- capture_warnings(out <- itemsPerFormConstraint(3, 9, targetValue = 5))
  expect_equal(warn[[1]], "Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.")
  expect_equal(out$d, rep(5, 3))
  expect_equal(out$operator, rep("<=", 3))

  expect_equal(attr(out, "info"), make_info("itemsPerForm<=5", whichForms = 1:3))

  expect_is(out, "constraint")
})

test_that("Items per Form Constraint returns errors", {
  expect_error(itemValuesConstraint(c(2, 4), 10, targetValue = 4),
               "The following arguments should have length 1: 'nForms', 'operator', 'targetValue'.")
  expect_error(itemsPerFormConstraint(2, operator = "=", targetValue = 12, itemIDs = 1:10),
               "'targetValue' should be smaller than or equal to 'nItems'.")
})

