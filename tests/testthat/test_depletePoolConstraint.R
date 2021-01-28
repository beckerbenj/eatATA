

test_that("deplete pool constraint", {
  suppressWarnings(out <- depletePoolConstraint(nForms = 3, nItems = 3))
  expect_equal(out$A_binary[1, ], c(1, 0, 0, 1, 0, 0, 1, 0, 0))
  expect_equal(out$A_binary[3, ], c(0, 0, 1, 0, 0, 1, 0, 0, 1))
  expect_equal(out$d, rep(1, 3))
  expect_equal(out$operators, rep(">=", 3))
})
