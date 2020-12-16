

test_that("Item Values Constraint", {
  out <- itemValuesConstraint(2, 4, 2:5, targetValue = 4)
  expect_equal(out[1, ], c(2:5, 0, 0, 0, 0, 0, -1, 4))
  expect_equal(out[2, ], c(0, 0, 0, 0, 2:5, 0, -1, 4))

  out <- itemValuesConstraint(3, 3, 1:3, operator = "=", 2)
  expect_equal(out[1, ], c(1:3, rep(0, 6), 0, 0, 2))
  expect_equal(out[3, ], c(rep(0, 6), 1:3, 0, 0, 2))

  expect_is(out, "Matrix")
})

test_that("Item Values Constraint returns errors", {
  expect_error(itemValuesConstraint(c(2, 4), 10, 1:10, targetValue = 4),
               "The following arguments should have length 1: 'nForms', 'nItems', 'operator', 'targetValue'.")
  expect_error(itemValuesConstraint(2, 10, 1:5, "=", 3),
               "The length of 'itemValues' should be equal to 'nItems'.")
  expect_error(itemValuesConstraint(2, 5, 1:5, "=", 20),
               "The 'targetValue' should be smaller than the sum of the 'itemValues'.")
})


test_that("Item Values Min Max and Threshold", {
  minMax <- itemValuesRange(2, 4, 2:5, range = c(3, 5))
  expect_equal(minMax[1:2, ], itemValuesMin(2, 4, 2:5, min = 3))
  expect_equal(minMax[3:4, ], itemValuesMax(2, 4, 2:5, 5))
  expect_equal(minMax, itemValuesDeviation(2, 4, 2:5, 4, 1))

  min <- itemValuesMin(3, 3, 1:3, 2)
  expect_equal(min[1,], c(1:3, rep(0, 6), 0, 1, 2))
  expect_equal(min[3,], c(rep(0, 6), 1:3, 0, 1, 2))

  max <- itemValuesMax(3, 3, 1:3, 4)
  expect_equal(max[1,], c(1:3, rep(0, 6), 0, -1, 4))
  expect_equal(max[3,], c(rep(0, 6), 1:3, 0, -1, 4))

  expect_is(minMax, "Matrix")
})

test_that("Item Min Max returns error", {
  expect_error(itemValuesRange(2, 4, 2:5,range = c(3, 2)),
               "The first value of 'range' should be smaller than second value of 'range'.")
})


