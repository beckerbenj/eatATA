

test_that("errors", {
  expect_error(calculateExpectedRT("a", phi = 1, zeta = 0, sdEpsi = 0.5),
               "'lambda' must be a numeric vector.")
  expect_error(calculateExpectedRT(1, phi = c("b", "a"), zeta = 0, sdEpsi = 0.5),
               "'phi' must be a numeric vector.")
  expect_error(calculateExpectedRT(1, phi = 1, zeta = "x", sdEpsi = 0.5),
               "'zeta' must be a numeric vector.")
  expect_error(calculateExpectedRT(1, phi = 1, zeta = 0, sdEpsi = "0.5"),
               "'sdEpsi' must be a numeric vector.")
  expect_error(calculateExpectedRT(1:2, phi = 1:2, zeta = 0, sdEpsi = 0.5),
               "'lambda', 'phi', and 'sdEpsi' must be of the same length.")
  expect_error(calculateExpectedRT(1, phi = 1:2, zeta = 0, sdEpsi = 1:2),
               "'lambda', 'phi', and 'sdEpsi' must be of the same length.")
})


test_that("normal", {
  out <- calculateExpectedRT(4, phi = 1, zeta = 0, sdEpsi = 0.5)
  expect_equal(round(out[1], 2), c(61.87))
})

test_that("multiple items", {
  out <- calculateExpectedRT(c(4, 5), phi = c(1, 1), zeta = 0, sdEpsi = c(0.5, 0.5))
  expect_equal(round(out[1], 2), c(61.87))
  expect_equal(round(out[2], 2), c(168.17))
})

test_that("multiple zetas", {
  out <- calculateExpectedRT(4, phi = 1, zeta = c(0, 1), sdEpsi = 0.5)
  expect_equal(round(out[1], 2), c(61.87))
  expect_equal(round(out[2], 2), c(22.76))
})

test_that("multiple items and multiple zetas", {
  out <- calculateExpectedRT(c(4, 5), phi = c(1, 1), zeta = c(0, 1), sdEpsi = c(0.5, 0.5))
  expect_equal(dim(out), c(2, 2))
  expect_equal(as.numeric(round(out[1, 1], 2)), c(61.87))
  expect_equal(as.numeric(round(out[2, 1], 2)), c(168.17))
  expect_equal(as.numeric(round(out[1, 2], 2)), c(22.76))
  expect_equal(colnames(out), c("zeta=0", "zeta=1"))
})
