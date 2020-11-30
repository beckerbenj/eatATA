

test_that("normal", {
  out <- calculateExpectedRT(4, phi = 1, zeta = 0, sdEpsi = 0.5)
  expect_equal(out[1], c(61.86781))
})

test_that("vectorized", {
  out <- calculateExpectedRT(c(4, 5), phi = c(1, 1), zeta = 0, sdEpsi = c(0.5, 0.5))
  expect_equal(round(out[1], 2), round(c(61.86781), 2))
  expect_equal(round(out[2], 2), round(c(168.1741), 2))
})
