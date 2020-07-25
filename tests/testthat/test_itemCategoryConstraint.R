

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


test_that("Item Category Min Max and Threshold", {
  minMax <- itemCategoryRange(2, 20, factor(rep(1:2, 10)), range = cbind(min = c(3, 4), max = c(5, 6)))
  expect_equal(minMax[1:4, ], itemCategoryMin(2, 20, factor(rep(1:2, 10)), c(3, 4)))
  expect_equal(minMax[5:8, ], itemCategoryMax(2, 20, factor(rep(1:2, 10)), c(5, 6)))
  expect_equal(minMax, itemCategoryDeviation(2, 20, factor(rep(1:2, 10)), c(4, 5), c(1, 1)))


  max <- itemCategoryMax(1, 3, factor(c(1, 2, 3)), max = c(1, 1, 1))
  expect_equal(max, itemCategoryConstraint(1, 3, factor(c(1, 2, 3)), targetValues = c(1, 1, 1)))

  min <- itemCategoryMin(1, 3, factor(c(1, 2, 3)), min = c(1, 1, 1))
  expect_equal(min[1, ], c(1, 0, 0, 0, 1, 1))
  expect_equal(min[2, ], c(0, 1, 0, 0, 1, 1))
  expect_equal(min[3, ], c(0, 0, 1, 0, 1, 1))

  expect_is(minMax, "Matrix")
})



test_that("Item Category Range returns errors", {
  expect_error(itemCategoryRange(2, 20, factor(rep(1:2, 10)), range = cbind(min = c(6, 4), max = c(5, 6))),
               "The values in the first column of 'range' should be smaller than the values in the second column of 'range'.")
  expect_error(itemCategoryRange(2, 20, factor(rep(1:2, 10)), range = c(min = c(4, 4), max = c(5, 6))),
               "itemCategories")
  expect_error(itemCategoryRange(2, 20, factor(rep(1:3, 10)), range = rbind(min = c(4, 4, 2), max = c(5, 6, 3))),
               "itemCategories")
  expect_error(itemCategoryRange(2, 20, factor(rep(1:2, 10)), range = rbind(min = c(4, 4, 2), max = c(5, 6, 3))),
               "itemCategories")
})


