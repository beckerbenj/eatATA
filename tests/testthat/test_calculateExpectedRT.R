

test_that("normal", {
  out <- calculateExpectedRT(4, phi = 1, zeta = 0, sdEpsi = 0.5)
  expect_equal(out[1], c(61.86781))
})
