
test_that("Errors", {
  expect_error(check_single_numeric(1:2, "vec"),
               "'vec' needs to be a numeric vector of length 1.")
  expect_error(check_single_numeric(c("a"), "vec"),
               "'vec' needs to be a numeric vector of length 1.")
})

test_that("Silent", {
  expect_silent(check_single_numeric(1, "vec"))
  expect_silent(check_single_numeric(1L, "vec"))
})
