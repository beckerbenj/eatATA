
test_that("Single Parameter Constraint", {
  out <- noItemOverlapConstraint(nForms = 2, nItems = 4, sign = 0)
  expect_equal(out[1, ], c(1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1))
  expect_equal(out[4, ], c(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1))

})
