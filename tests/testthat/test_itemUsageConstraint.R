test_that("Item Usage Constraint", {
  out <- itemUsageConstraint(2, 4)
  expect_equal(out$A_binary[1, ], c(1, 0, 0, 0, 1, 0, 0, 0))
  expect_equal(out$A_binary[4, ], c(0, 0, 0, 1, 0, 0, 0, 1))
  expect_equal(out$A_real, NULL)
  expect_equal(out$operator, rep("<=", 4))
  expect_equal(out$d, rep(1, 4))

  out <- itemUsageConstraint(3, 3, operator = "=", targetValue = 2)
  expect_equal(out$A_binary[1, ], c(1, 0, 0, 1, 0, 0, 1, 0, 0))
  expect_equal(out$A_binary[2, ], c(0, 1, 0, 0, 1, 0, 0, 1, 0))
  expect_equal(out$A_real, NULL)
  expect_equal(out$operator, rep("=", 3))
  expect_equal(out$d, rep(2, 3))

  out <- itemUsageConstraint(2, 4, whichItems = c(1, 4), formValues = c(1, -1), targetValue = 0)
  expect_equal(out$A_binary[1, ], c(1, 0, 0, 0, -1, 0, 0, 0))
  expect_equal(out$A_binary[2, ], c(0, 0, 0, 1, 0, 0, 0, -1))
  expect_equal(out$A_real, NULL)
  expect_equal(out$operator, rep("<=", 2))
  expect_equal(out$d, rep(0, 2))


  expect_is(out, "constraint")
})

test_that("Item Usage Constraint returns errors", {
  expect_error(itemUsageConstraint(c(2, 4), 10), "All arguments should have length 1")
  expect_error(itemUsageConstraint(2, 10, "=", 3), "'value' should be smaller than or equal to 'nForms'.")
})

