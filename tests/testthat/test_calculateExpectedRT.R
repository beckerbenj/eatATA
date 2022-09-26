

test_that("errors", {
  expect_error(calculateExpectedRT(2, phi = 1, zeta = 0, sdEpsi = 0.5),
               "This function is deprecated. See '?getMean3PLN' for more details.", fixed = TRUE)
  expect_error(calculateExpectedRTvar(2, phi = 1, zeta = 0, sdEpsi = 0.5),
               "This function is deprecated. See '?getVar3PLN' for more details.", fixed = TRUE)
})
