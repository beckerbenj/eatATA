


test_that("determine target value automatically", {
  out <- detTargetValue(nForms = 3, itemValues = c(0, 1, 1, 1, 0, 1, 1, 0, 0, 1, 1))
  expect_equal(out, 2.5)

  out <- detTargetValue(nForms = 3, itemValues = c(0, 1, 1, 1, 0, 1, 1, 0, 0, 1, 0))
  expect_equal(out, 2)

  out <- detTargetValue(nForms = 3, itemValues = rep(1, 6))
  expect_equal(out, 2)

  expect_error(detTargetValue(nForms = 3, itemValues = c(0, 1, 1, 1, 0, 1, 1, 0, 0, 2)))
})

test_that("auto item value error", {
  expect_error(autoItemValuesMinMax(nForms = 2, nItems = 4, itemValues = c(1, 2, 1, 1), threshold = 0.5),
               "autoItemValuesMinMax only works for (dichotomous) dummy indicators with values 0 and 1. See itemValuesMinMax for more flexibility.",
               fixed = TRUE)
})

test_that("auto item value", {
  out <- autoItemValuesMinMax(nForms = 2, nItems = 4, itemValues = c(1, 1, 1, 1), threshold = 0)
  expect_equal(out[1, ], c(1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1.5))
  expect_equal(out[4, ], c(0, 0, 0, 0, 1, 1, 1, 1, 0, -1, 2.5))

  expect_message(autoItemValuesMinMax(nForms = 2, nItems = 5, itemValues = c(1, 1, 1, 1, 1), threshold = 0),
  "Target value: 2.5	 Values in range: 2, 3")
  out <- autoItemValuesMinMax(nForms = 2, nItems = 5, itemValues = c(1, 1, 1, 1, 1), threshold = 0)
  expect_equal(out[1, ], c(1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 2))
  expect_equal(out[4, ], c(0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, -1, 3))

  out <- autoItemValuesMinMax(nForms = 2, nItems = 4, itemValues = c(1, 1, 1, 1), threshold = 1)
  expect_equal(out[1, ], c(1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0.5))
  expect_equal(out[4, ], c(0, 0, 0, 0, 1, 1, 1, 1, 0, -1, 3.5))
})
