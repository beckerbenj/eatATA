test_that("Across Forms Constraint works", {
  out <- acrossFormsConstraint(nForms = 3,
                               targetValue = 4,
                               whichForms = c(1, 3),
                               itemValues = c(rep(1, 10), rep(0, 10)),
                               itemIDs = 1:20)
  expect_equal(out$A_binary[1, ], c(rep(c(1, 0), each = 10),
                                    rep(0, 20),
                                    rep(c(1, 0), each = 10)))

  expect_equal(out$A_real, NULL)
  expect_equal(out$operators, "<=")
  expect_equal(out$d, 4)

  out <- acrossFormsConstraint(nForms = 3, nItems = 20,
                               operator = "=", targetValue = 4,
                               whichForms = c(1, 3),
                               whichItems = 1:10,
                               itemIDs = 1:20)
  expect_equal(out$A_binary[1, ], c(rep(c(1, 0), each = 10),
                                    rep(0, 20),
                                    rep(c(1, 0), each = 10)))

  expect_equal(out$A_real, NULL)
  expect_equal(out$operators, "=")
  expect_equal(out$d, 4)

  expect_is(out, "constraint")
  expect_is(out$A_binary, "Matrix")
})

test_that("Across Forms Constraint returns errors", {
  expect_error(acrossFormsConstraint(nForms = 3,
                                     operator = "=", targetValue = 4,
                                     whichForms = c(1, 3)),
               "Impossible to infer the number of items in the pool. Specify either 'itemIDs' or 'nItems' or 'itemValues'")
  expect_error(acrossFormsConstraint(nForms = 3,
                                     operator = "=", targetValue = 4,
                                     whichForms = c(1, 3),
                                     itemValues = c(rep(1, 10), rep(0, 10)),
                                     itemIDs = 1:21),
               "The length of 'itemIDs' and 'itemValues' should correspond.")

  expect_error(acrossFormsConstraint(nForms = 3,
                                     operator = "=", targetValue = 4,
                                     whichForms = c(1, 3),
                                     itemValues = c(rep(1, 10), rep(0, 10)),
                                     itemIDs = 1:20,
                                     info_text = c("two", "strings")),
               "'info_text' should be a vector of length 1.")

  expect_error(acrossFormsConstraint(nForms = 3,
                                     operator = "=", targetValue = 4,
                                     whichForms = c(1, 3),
                                     itemValues = c(rep(1, 10), rep(0, 10)),
                                     itemIDs = 1:20,
                                     info_text = 2),
               "'info_text' should be a character vector.")
})






