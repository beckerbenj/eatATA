

test_that("Item Category Constraint", {
  out <- itemCategoryConstraint(2, 4, factor(c(1, 1, 2, 2)), "=", targetValues = c(1, 2))
  expect_equal(out[1, ], c(1, 1, 0, 0, rep(0, 4), 0, 0, 1))
  expect_equal(out[2, ], c(rep(0, 4), 1, 1, 0, 0, 0, 0, 1))
  expect_equal(out[3, ], c(0, 0, 1, 1, rep(0, 4), 0, 0, 2))
  expect_equal(out[4, ], c(rep(0, 4), 0, 0, 1, 1, 0, 0, 2))

  out <- itemCategoryConstraint(1, 3, factor(c(1, 2, 3)), targetValues = c(1, 1, 1))
  expect_equal(out[1, ], c(1, 0, 0, 0, -1, 1))
  expect_equal(out[2, ], c(0, 1, 0, 0, -1, 1))
  expect_equal(out[3, ], c(0, 0, 1, 0, -1, 1))

  expect_is(out, "Matrix")
})

test_that("Item Category Constraint returns errors", {
  expect_error(itemCategoryConstraint(1, 3, c(1, 2, 3), targetValues = c(1, 1, 1)),
               "'itemCategories' should be a factor.")
  expect_error(itemCategoryConstraint(2, 4, factor(c(1, 2, 2)), "=", targetValues = c(1, 2)),
               "The lenght of 'itemCategories' should be equal to 'nItems'.")
  expect_error(itemCategoryConstraint(2, 4, factor(c(1, 2, 2, 1)), "=", targetValues = 1),
               "The number of 'targetValues' should correspond with the number of levels in 'itemCategories'.")
  expect_error(itemCategoryConstraint(2, c(1:4), factor(c(1, 2, 2, 1)), "=", targetValues = c(1, 2)),
               "The following arguments should have length 1: 'nForms', 'nItems', 'operator'.")
})

