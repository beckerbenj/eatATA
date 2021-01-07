

test_that("Items per Form Constraint works", {
  out <- itemsPerFormConstraint(2, 4, operator = "=", targetValue = 2)
  expect_equal(out$A_binary[1, ], c(1, 1, 1, 1, 0, 0, 0, 0))
  expect_equal(out$A_binary[2, ], c(0, 0, 0, 0, 1, 1, 1, 1))

  out <- itemsPerFormConstraint(3, 9, targetValue = 5)
  expect_equal(out$d, rep(5, 3))
  expect_equal(out$operator, rep("<=", 3))

  expect_equal(attr(out, "info"), make_info("itesmPerForm<=5", whichForms = 1:3))

  expect_is(out, "constraint")
})

test_that("Items per Form Constraint returns errors", {
  expect_error(itemValuesConstraint(c(2, 4), 10, targetValue = 4),
               "The following arguments should have length 1: 'nForms', 'nItems', 'operator', 'targetValue'.")
  expect_error(itemsPerFormConstraint(2, 10, "=", 12),
               "'targetValue' should be smaller than or equal to 'nItems'.")
})

