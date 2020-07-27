
itemValues <- rep(1:4, times = 20)

test_that("computeTargetValues works", {
  expect_equal(computeTargetValues(c(0, 1, 1, 1, 0), 2, allowedDeviation = 1), c(min = 0.5, max = 2.5))
  expect_equal(computeTargetValues(2:5, 2), sum(2:5)/2)
  expect_equal(computeTargetValues(1:9, 2, testLength = 2), mean(1:9) * 2)
  expect_equal(computeTargetValues(-5:5, 2, allowedDeviation = 1),
               sum(-5:5)/2 + c(min = -1, max = 1))
  expect_equal(computeTargetValues(itemValues, 2, allowedDeviation = .1, relative = TRUE),
               sum(itemValues)/2 * c(min = .9, max = 1.1))
})



test_that("computeTargetValues works for item categories", {
  expect_equal(computeTargetValues(factor(itemValues), 2),
               matrix(10, ncol = 2, nrow = 4, dimnames = list(1:4, c("min", "max"))))
  expect_equal(computeTargetValues(factor(itemValues), 3),
               matrix(rep(c(6, 7), each = 4), ncol = 2, nrow = 4, dimnames = list(1:4, c("min", "max"))))
  expect_equal(computeTargetValues(factor(itemValues), 2, allowedDeviation = rep(1, 4))               ,
               matrix(rep(c(9, 11), each = 4), ncol = 2, nrow = 4, dimnames = list(1:4, c("min", "max"))))
  expect_equal(computeTargetValues(factor(itemValues), 2, allowedDeviation = rep(.29, 4), relative = TRUE),
               computeTargetValues(factor(itemValues), 2, allowedDeviation = rep(.29, 4), relative = TRUE))
})


test_that("computeTargetValues returns errors", {
  expect_error(computeTargetValues(itemValues, 2, allowedDeviation = 1.1, relative = TRUE),
               "When 'relative == TRUE' the 'allowedDeviation' should be expressed as a proportion between 0 and 1.")

  expect_error(computeTargetValues(factor(itemValues), 2, allowedDeviation = 2),
               "The number of 'allowedDeviations' should correspond with the number of levels in 'itemValues'.")
})
