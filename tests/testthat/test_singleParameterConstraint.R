

test_that("Single Parameter Constraint", {
  out <- singleParameterConstraint(2, 4, itemValues = c(1, 2, 3, 4), targetValues = 8, tolerance = 1.3)
  expect_equal(out[1, ], c(1, 2, 3, 4, 0, 0, 0, 0, 0, -1, 9.3))
  expect_equal(out[4, ], c(0, 0, 0, 0, 1, 2, 3, 4, 0, 1, 6.7))

})
