

test_that("deplete pool constraint", {
  out <- depletePoolConstraint(nForms = 3, nItems = 3)
  expect_equal(out[1, ], c(1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 1))
  expect_equal(out[3, ], c(0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 1))
})
