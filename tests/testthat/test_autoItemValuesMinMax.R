
test_that("auto item value", {
  out <- autoItemValuesMinMaxConstraint(nForms = 2, itemValues = c(1, 1, 1, 1), allowedDeviation = 0, verbose = FALSE, itemIDs = 1:4)
  expect_equal(out$A_binary[1, ], c(1, 1, 1, 1, 0, 0, 0, 0))
  expect_equal(out$A_binary[4, ], c(0, 0, 0, 0, 1, 1, 1, 1))
  expect_equal(out$d, c(min = 2 , min = 2, max = 2, max = 2))

  out <- autoItemValuesMinMaxConstraint(nForms = 2, itemValues = c(1, 1, 1, 1), allowedDeviation = .5, verbose = FALSE, itemIDs = 1:4)
  expect_equal(out$d, c(min = 1.5, min = 1.5, max = 2.5, max = 2.5))
  expect_equal(out$operators, c(">=", ">=", "<=", "<="))

  out <- autoItemValuesMinMaxConstraint(nForms = 2, itemValues = c(1, 1, 1, 1), verbose = FALSE, itemIDs = 1:4)
  expect_equal(out$d, c(2, 2))
  expect_equal(out$operators, c("=", "="))

  out <- autoItemValuesMinMaxConstraint(nForms = 2, itemValues = c(1, 1, 1, 1, 1), allowedDeviation = .5, verbose = FALSE, itemIDs = 1:5)
  expect_equal(out$A_binary[1, ], c(1, 1, 1, 1, 1, 0, 0, 0, 0, 0))
  expect_equal(out$d, c(min = 2, min = 2, max = 3, max = 3))
  expect_equal(out$operators, c(">=", ">=", "<=", "<="))

  expect_equal(autoItemValuesMinMaxConstraint(nForms = 2, itemValues = c(1, 1, 1, 1), allowedDeviation = 1, verbose = FALSE, itemIDs = 1:4),
               autoItemValuesMinMaxConstraint(nForms = 2, itemValues = c(1, 1, 1, 1), allowedDeviation = .5, relative = TRUE, verbose = FALSE, itemIDs = 1:4))
})

test_that("auto item value with specific testlength", {
  out <- autoItemValuesMinMaxConstraint(nForms = 2, itemValues = c(1, 1, 1, 1), testLength = 1,
                              allowedDeviation = 0, verbose = FALSE, itemIDs = 1:4)
  expect_equal(out$A_binary[1, ], c(1, 1, 1, 1, 0, 0, 0, 0))
  expect_equal(out$A_binary[4, ], c(0, 0, 0, 0, 1, 1, 1, 1))
  expect_equal(out$d, c(min = 1 , min = 1, max = 1, max = 1))
})

test_that("auto item value gives the correct messages + warnings", {
  expect_message(out <- autoItemValuesMinMaxConstraint(nForms = 2, itemValues = c(1, 1, 1, 1, 1), itemIDs = 1:5),
                 "The target value per test form is: 2.5")

  expect_message(out <- autoItemValuesMinMaxConstraint(nForms = 2, itemValues = c(1, 1, 1, 1, 1), allowedDeviation = .5, itemIDs = 1:5),
               "The minimum and maximum values per test form are: min = 2 - max = 3")

  out <- capture_output(expect_message(out <- autoItemValuesMinMaxConstraint(nForms = 2, itemValues = factor(rep(1:2, 5)), itemIDs = 1:10),
                 "The minimum and maximum frequences per test form for each item category are"))

  expect_warning(out <- autoItemValuesMinMaxConstraint(nForms = 2, itemValues = c(1, 1, 1, 1), allowedDeviation = 0, verbose = FALSE),
                  "Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.")
})
