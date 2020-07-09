

test_that("Single Parameter Constraint", {
  out <- singleParameterConstraint(2, 4, itemValues = c(1, 2, 3, 4), targetValues = 8, tolerance = 1.3)
  expect_equal(out[1, ], c(1, 2, 3, 4, 0, 0, 0, 0, 0, -1, 9.3))
  expect_equal(out[4, ], c(0, 0, 0, 0, 1, 2, 3, 4, 0, 1, 6.7))

})

test_that("Single Parameter Constraint for number of items", {
  out <- singleParameterConstraint(nForms = 2, nItems = 4, itemValues = c(1, 1, 1, 1), tolerance = 0.5)
  expect_equal(out[1, ], c(1, 1, 1, 1, 0, 0, 0, 0, 0, -1, 2.5))
  expect_equal(out[4, ], c(0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 1.5))

  out <- singleParameterConstraint(nForms = 2, nItems = 4, itemValues = c(1, 1, 1, 1), tolerance = 1.5)
  expect_equal(out[1, ], c(1, 1, 1, 1, 0, 0, 0, 0, 0, -1, 3.5))
  expect_equal(out[4, ], c(0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 0.5))
})

test_that("determine target value automatically", {
  out <- detTargetValue(nForms = 3, itemValues = c(0, 1, 1, 1, 0, 1, 1, 0, 0, 1, 1))
  expect_equal(out, 2.5)

  out <- detTargetValue(nForms = 3, itemValues = c(0, 1, 1, 1, 0, 1, 1, 0, 0, 1, 0))
  expect_equal(out, 2)

  out <- detTargetValue(nForms = 3, itemValues = rep(1, 6))
  expect_equal(out, 2)

  expect_error(detTargetValue(nForms = 3, itemValues = c(0, 1, 1, 1, 0, 1, 1, 0, 0, 2)))
})
