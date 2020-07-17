

test_that("Items per Form Constraint", {
  out <- itemsPerFormConstraint(2, 4, operator = "=", targetValue = 2)
  expect_equal(out[1, ], c(1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 2))
  expect_equal(out[2, ], c(0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 2))

  out <- itemsPerFormConstraint(3, 9, targetValue = 5)
  expect_equal(out[1, ], c(rep(c(1, 0, 0), each = 9), 0, -1, 5))
  expect_equal(out[3, ], c(rep(c(0, 0, 1), each = 9), 0, -1, 5))

  expect_is(out, "Matrix")
})

test_that("Items per Form Constraint returns errors", {
  expect_error(itemValuesConstraint(c(2, 4), 10, targetValue = 4),
               "The following arguments should have length 1: 'nForms', 'nItems', 'operator', 'targetValue'.")
  expect_error(itemsPerFormConstraint(2, 10, "=", 12),
               "'targetValue' should be smaller than or equal to 'nItems'.")
})

