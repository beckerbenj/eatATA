test_that("Item Usage Constraint", {
  out <- itemUsageConstraint(2, itemIDs = 1:4)
  expect_equal(out$A_binary[1, ], c(1, 0, 0, 0, 1, 0, 0, 0))
  expect_equal(out$A_binary[4, ], c(0, 0, 0, 1, 0, 0, 0, 1))
  expect_equal(out$A_real, NULL)
  expect_equal(out$operator, rep("<=", 4))
  expect_equal(out$d, rep(1, 4))

  suppressWarnings(out <- itemUsageConstraint(3, 3, operator = "=", targetValue = 2))
  expect_equal(out$A_binary[1, ], c(1, 0, 0, 1, 0, 0, 1, 0, 0))
  expect_equal(out$A_binary[2, ], c(0, 1, 0, 0, 1, 0, 0, 1, 0))
  expect_equal(out$A_real, NULL)
  expect_equal(out$operator, rep("=", 3))
  expect_equal(out$d, rep(2, 3))

  out <- itemUsageConstraint(2, 4, whichItems = c("it1", "it4"),
                             formValues = c(1, -1), targetValue = 0,
                             itemIDs = paste0("it", 1:4))
  expect_equal(out$A_binary[1, ], c(1, 0, 0, 0, -1, 0, 0, 0))
  expect_equal(out$A_binary[2, ], c(0, 0, 0, 1, 0, 0, 0, -1))
  expect_equal(out$A_real, NULL)
  expect_equal(out$operator, rep("<=", 2))
  expect_equal(out$d, rep(0, 2))

  out2 <- itemUsageConstraint(2, 4, whichItems = c(1, 4),
                             formValues = c(1, -1), targetValue = 0,
                             itemIDs = paste0("it", 1:4))
  expect_equal(out, out2)

  expect_is(out, "constraint")
})

test_that("Item Usage Constraint returns errors", {
  expect_error(itemUsageConstraint(c(2, 4), 10, itemIDs = 1:10),
               "The following arguments should have length 1: 'nForms', 'nItems', 'operator', 'targetValue'.")
  expect_error(itemUsageConstraint(2, 10, operator = "=", targetValue = 3, itemIDs = 1:10),
               "The 'targetValue' should be smaller than the sum of the 'formValues'.")
  expect_error(itemUsageConstraint(2, 10, 1:3, operator = "=", targetValue = 1, itemIDs = 1:10),
               "The length of 'formValues' should be equal to 'nForms'.")
  expect_error(itemUsageConstraint(2, 10, rep(1, 2), operator = "=",
                                   targetValue = 1, whichItems = c(1, 11), itemIDs = 1:10),
               "'whichItems' should be a subset of either all the possible items numbers given 'nItems', or of the 'itemIDs")
  expect_warning(out <- itemUsageConstraint(2, 4),
                 "'itemIDs' is missing. 'itemIDs' will be generated automatically.")
})

