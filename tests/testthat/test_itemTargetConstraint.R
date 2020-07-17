
test_that("Item Target Constraint", {
  out <- itemTargetConstraint(nForms = 2, nItems = 4, c(1, 0.5, 1.5, 2), targetValue = 1)
  #out2 <- targetConstraint(nForms = 2, nItems = 4,  itemValues = matrix(c(1, 0.5, 1.5, 2), nrow = 1), targetValues = 1, thetaPoints = matrix(c(0)))
  expect_equal(out[1, ], c(1, 0.5, 1.5, 2, 0, 0, 0, 0, -1, -1, 1))
  expect_equal(out[4, ], c(0, 0, 0, 0, 1, 0.5, 1.5, 2, 1, 1, 1))

})
