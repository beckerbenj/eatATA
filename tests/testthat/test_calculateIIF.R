test_that("errors", {
  expect_error(calculateIIF(theta = "a", A = 1, B = 0),
               "'theta' must be a numeric vector.")
  expect_error(calculateIIF(theta = 1, A = c("b", "a"), B = 0, C = 0.5),
               "'A' must be a numeric vector.")
  expect_error(calculateIIF(theta = 1, A = 1, B = "x", C = 0.5),
               "'B' must be a numeric vector.")
  expect_error(calculateIIF(theta = 1, A = 1, B = 0, C = "0.5"),
               "'C' must be a numeric vector.")

  expect_error(calculateIIF(theta = 1, A = 1:2, B = 0, C = 0.5),
               "'A', 'B', and 'C' must be of the same length.")
  expect_error(calculateIIF(theta = 1, A = 1:2, B = 0, C = 1:2),
               "'A', 'B', and 'C' must be of the same length.")
})


test_that("normal", {
  out <- calculateIIF(theta = 0, A = 1, B = 0)
  expect_equal(round(out[1], 2), c(0.72))
})

test_that("multiple items", {
  out <- calculateIIF(theta = 0, A = c(1, 1), B = c(0, 1))
  expect_equal(round(out[1], 2), c(0.72))
  expect_equal(round(out[2], 2), c(0.38))
})

test_that("multiple thetas", {
  out <- calculateIIF(A = 1, B = 0, theta = c(0, 1))
  expect_equal(round(out[1], 2), c(0.72))
  expect_equal(round(out[2], 2), c(0.38))
})

test_that("multiple items and multiple zetas", {
  out <- calculateIIF(B = c(0, 5), A = c(1, 1), theta = c(0, 1))
  expect_equal(dim(out), c(2, 2))
  expect_equal(as.numeric(round(out[1, 1], 2)), c(0.72))
  expect_equal(as.numeric(round(out[2, 1], 2)), c(0))
  expect_equal(as.numeric(round(out[1, 2], 2)), c(0.38))
  expect_equal(colnames(out), c("theta=0", "theta=1"))
})
