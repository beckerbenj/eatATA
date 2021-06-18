test_that("Item Values Constraint", {
  out <- itemValuesConstraint(2, 2:5, targetValue = 4, itemIDs = 1:4)
  expect_equal(out$A_binary[1, ], c(2:5, 0, 0, 0, 0))
  expect_equal(out$A_binary[2, ], c(0, 0, 0, 0, 2:5))

  expect_equal(out$A_real, NULL)
  expect_equal(out$operators, rep("<=", 2))
  expect_equal(out$d, c(4, 4))

  suppressWarnings(out <- itemValuesConstraint(3, 1:3, operator = "=", 2))
  expect_equal(out$A_binary[1, ], c(1:3, rep(0, 6)))
  expect_equal(out$A_binary[3, ], c(rep(0, 6), 1:3))

  expect_equal(out$A_real, NULL)
  expect_equal(out$operators, rep("=", 3))
  expect_equal(out$d, rep(2, 3))

  expect_is(out, "constraint")
  expect_is(out$A_binary, "Matrix")
})

test_that("Item Values Constraint returns errors", {
  expect_error(itemValuesConstraint(c(2, 4), 1:10, targetValue = 4, itemIDs = 1:10),
               "'nForms' should be a vector of length 1.")
  expect_error(itemValuesConstraint(2, 1:5, "=", 3, itemIDs = 1:4),
               "The length of 'itemIDs' and 'itemValues' should correspond.")
  expect_error(itemValuesConstraint(2, 1:5, "=", 20, itemIDs = 1:5),
               "The 'targetValue' should be smaller than the sum of the 'itemValues'.")

  expect_error(itemValuesConstraint(2, 2:5, targetValue = 4, info_text = c("two", "strings"),
                                    itemIDs = 1:4),
               "'info_text' should be a vector of length 1.")
})





test_that("Item Values Min Max and Threshold", {
  minMax <- itemValuesRangeConstraint(2, 2:5, range = c(3, 5), itemIDs = 1:4)
  expect_equal(minMax,
               combineConstraints(
                 itemValuesConstraint(2, 2:5, ">=", 3, itemIDs = 1:4),
                 itemValuesConstraint(2, 2:5, "<=", 5, itemIDs = 1:4)))
  expect_equal(minMax, itemValuesDeviationConstraint(2, 2:5, 4, 1, itemIDs = 1:4))

  min <- itemValuesMinConstraint(3, 1:3, 2, itemIDs = 1:3)
  expect_equal(min$A_binary[1,], c(1:3, rep(0, 6)))
  expect_equal(min$A_binary[3,], c(rep(0, 6), 1:3))
  expect_equal(min$operator, rep(">=", 3))
  expect_equal(min$d, rep(2, 3))

  max <- itemValuesMaxConstraint(3, 1:3, 4, itemIDs = 1:3)
  expect_equal(max$operator, rep("<=", 3))
  expect_equal(max$d, rep(4, 3))

  expect_is(minMax, "constraint")
})

test_that("Item Min Max returns error", {
  expect_error(itemValuesRangeConstraint(2, 2:5,range = c(3, 2)),
               "The first value of 'range' should be smaller than second value of 'range'.")
})


