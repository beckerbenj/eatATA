
test_that("auto item value", {
  out <- autoItemValuesMinMax(nForms = 2, itemValues = c(1, 1, 1, 1), allowedDeviation = 0, verbose = FALSE)
  expect_equal(out[1, ], c(1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 2))
  expect_equal(out[4, ], c(0, 0, 0, 0, 1, 1, 1, 1, 0, -1, 2))

  out <- autoItemValuesMinMax(nForms = 2, itemValues = c(1, 1, 1, 1), allowedDeviation = .5, verbose = FALSE)
  expect_equal(out[1, ], c(1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1.5))
  expect_equal(out[4, ], c(0, 0, 0, 0, 1, 1, 1, 1, 0, -1, 2.5))

  out <- autoItemValuesMinMax(nForms = 2, itemValues = c(1, 1, 1, 1), verbose = FALSE)
  expect_equal(out[1, ], c(1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 2))
  expect_equal(out[2, ], c(0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 2))

  out <- autoItemValuesMinMax(nForms = 2, itemValues = c(1, 1, 1, 1, 1), allowedDeviation = .5, verbose = FALSE)
  expect_equal(out[1, ], c(1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 2))
  expect_equal(out[4, ], c(0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, -1, 3))

  expect_equal(autoItemValuesMinMax(nForms = 2, itemValues = c(1, 1, 1, 1), allowedDeviation = 1, verbose = FALSE),
               autoItemValuesMinMax(nForms = 2, itemValues = c(1, 1, 1, 1), allowedDeviation = .5, relative = TRUE, verbose = FALSE))
})


test_that("auto item value gives the correct messages", {
  expect_message(out <- autoItemValuesMinMax(nForms = 2, itemValues = c(1, 1, 1, 1, 1)),
                 "The target value per test form is: 2.5")

  expect_message(out <- autoItemValuesMinMax(nForms = 2, itemValues = c(1, 1, 1, 1, 1), allowedDeviation = .5),
               "The minimum and maximum values per test form are: min = 2 - max = 3")

  out <- capture_output(expect_message(out <- autoItemValuesMinMax(nForms = 2, itemValues = factor(rep(1:2, 5))),
                 "The minimum and maximum frequences per test form for each item category are"))
})
