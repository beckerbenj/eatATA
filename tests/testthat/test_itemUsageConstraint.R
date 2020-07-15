

test_that("Item Usage Constraint", {
  out <- itemUsageConstraint(2, 4)
  expect_equal(out[1, ], c(1, 0, 0, 0, 1, 0, 0, 0, 0, -1, 1))
  expect_equal(out[4, ], c(0, 0, 0, 1, 0, 0, 0, 1, 0, -1, 1))

  out <- itemUsageConstraint(3, 3, operator = "=", 2)
  expect_equal(out[1, ], c(1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 2))
  expect_equal(out[2, ], c(0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 2))

  expect_is(out, "Matrix")
})

test_that("Item Usage Constraint returns errors", {
  expect_error(itemUsageConstraint(c(2, 4), 10), "All arguments should have length 1")
  expect_error(itemUsageConstraint(2, 10, "=", 3), "'value' should be smaller than or equal to 'nForms'.")
})

