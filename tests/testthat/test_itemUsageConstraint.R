

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

test_that("Item Usage Constraint specific items", {
  out <- itemUsageConstraint(2, itemIDs = paste0("item", 1:4), whichItems = 3, operator = "=")
  expect_equal(out$A_binary[1, ], c(0, 0, 1, 0, 0, 0, 1, 0))
  expect_equal(nrow(out$A_binary), 1)
  expect_equal(out$A_real, NULL)
  expect_equal(out$operator, "=")
  expect_equal(out$d, 1)
})

test_that("Item Usage Constraint returns errors", {
  expect_error(itemUsageConstraint(c(2, 4), 10, itemIDs = 1:10),
               "'nForms' should be a vector of length 1.")
  expect_error(itemUsageConstraint(2, 10, operator = "=", targetValue = 3, itemIDs = 1:10),
               "The 'targetValue' should be smaller than the sum of the 'formValues'.")
  expect_error(itemUsageConstraint(2, 10, 1:3, operator = "=", targetValue = 1, itemIDs = 1:10),
               "'formValues' should be a vector of length 2.")
  expect_error(itemUsageConstraint(2, 10, rep(1, 2), operator = "=",
                                   targetValue = 1, whichItems = c(1, 11), itemIDs = 1:10),
               "Some values in 'whichItems' are out of range. That is, higher than the length of 'itemIDs'.")
  expect_warning(out <- itemUsageConstraint(2, 4),
                 "'itemIDs' is missing. 'itemIDs' will be generated automatically.")
})

