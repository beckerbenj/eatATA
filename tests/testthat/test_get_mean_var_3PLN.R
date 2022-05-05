

test_that("errors", {
  expect_error(get_mean_3PLN("a", phi = 1, zeta = 0, sdEpsi = 0.5),
               "'lambda' must be a numeric vector.")
  expect_error(get_mean_3PLN(1, phi = c("b", "a"), zeta = 0, sdEpsi = 0.5),
               "'phi' must be a numeric vector.")
  expect_error(get_mean_3PLN(1, phi = 1, zeta = "x", sdEpsi = 0.5),
               "'zeta' must be a numeric vector.")
  expect_error(get_mean_3PLN(1, phi = 1, zeta = 0, sdEpsi = "0.5"),
               "'sdEpsi' must be a numeric vector.")
  expect_error(get_mean_3PLN(1:2, phi = 1:2, zeta = 0, sdEpsi = 0.5),
               "'lambda', 'phi', and 'sdEpsi' must be of the same length.")
  expect_error(get_mean_3PLN(1, phi = 1:2, zeta = 0, sdEpsi = 1:2),
               "'lambda', 'phi', and 'sdEpsi' must be of the same length.")

  expect_error(get_mean_2PLN("a", zeta = 0, sdEpsi = 0.5),
               "'lambda' must be a numeric vector.")
  expect_error(get_mean_2PLN(1, zeta = "x", sdEpsi = 0.5),
               "'zeta' must be a numeric vector.")
  expect_error(get_mean_2PLN(1, zeta = 0, sdEpsi = "0.5"),
               "'sdEpsi' must be a numeric vector.")
  expect_error(get_mean_2PLN(1:2, zeta = 0, sdEpsi = 0.5),
               "'lambda', 'phi', and 'sdEpsi' must be of the same length.")
  expect_error(get_mean_2PLN(1, zeta = 0, sdEpsi = 1:2),
               "'lambda', 'phi', and 'sdEpsi' must be of the same length.")
})


test_that("normal", {
  out <- get_mean_3PLN(4, phi = 1, zeta = 0, sdEpsi = 0.5)
  out2 <- get_mean_2PLN(4, zeta = 0, sdEpsi = 0.5)
  expect_equal(round(out[1], 2), c(61.87))
  expect_equal(out, out2)
})

test_that("multiple items", {
  out <- get_mean_3PLN(c(4, 5), phi = c(1, 1), zeta = 0, sdEpsi = c(0.5, 0.5))
  out2 <- get_mean_3PLN(c(4, 5), zeta = 0, sdEpsi = c(0.5, 0.5))
  expect_equal(round(out[1], 2), c(61.87))
  expect_equal(round(out[2], 2), c(168.17))
  expect_equal(out, out2)
})

test_that("multiple zetas", {
  out <- get_mean_3PLN(4, phi = 1, zeta = c(0, 1), sdEpsi = 0.5)
  expect_equal(round(out[1], 2), c(61.87))
  expect_equal(round(out[2], 2), c(22.76))
})

test_that("multiple items and multiple zetas", {
  out <- get_mean_3PLN(c(4, 5), phi = c(1, 1), zeta = c(0, 1), sdEpsi = c(0.5, 0.5))
  expect_equal(dim(out), c(2, 2))
  expect_equal(as.numeric(round(out[1, 1], 2)), c(61.87))
  expect_equal(as.numeric(round(out[2, 1], 2)), c(168.17))
  expect_equal(as.numeric(round(out[1, 2], 2)), c(22.76))
  expect_equal(colnames(out), c("zeta=0", "zeta=1"))
})

test_that("normal variance", {
  out <- get_var_3PLN(4, phi = 1, zeta = 0, sdEpsi = 0.5)
  expect_equal(round(out[1], 2), c(1087.14))
})


test_that("getCumulantRT works", {
  my_zeta <- c(1:3)
  out <- get_cumulant_3PLN(zeta = my_zeta,
                lambda = c(rep(1:2, each = 2)),
                phi = seq(0.5, 0.8, length.out = 4),
                sdEpsi = seq(0.4, 0.25, length.out = 4))
  expect_equal(length(out), 3)
  expect_equal(dim(out[[1]]), c(4,3))
  expect_equal(colnames(out[[1]]), paste0("my_zeta=", my_zeta))
})
