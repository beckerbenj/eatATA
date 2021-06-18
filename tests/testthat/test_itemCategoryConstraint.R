

test_that("Item Category Constraint", {
  out <- itemCategoryConstraint(2, factor(c(1, 1, 2, 2)), "=", targetValues = c(1, 2), itemIDs = 1:4)
  expect_equal(out$A_binary[1, ], c(1, 1, 0, 0, rep(0, 4)))
  expect_equal(out$A_binary[2, ], c(rep(0, 4), 1, 1, 0, 0))
  expect_equal(out$A_binary[3, ], c(0, 0, 1, 1, rep(0, 4)))
  expect_equal(out$A_binary[4, ], c(rep(0, 4), 0, 0, 1, 1))

  out <- itemCategoryConstraint(1, factor(c(1, 2, 3)), targetValues = c(1, 1, 1), itemIDs = 1:3)
  expect_equal(out$A_binary[1, ], c(1, 0, 0))
  expect_equal(out$A_binary[2, ], c(0, 1, 0))
  expect_equal(out$A_binary[3, ], c(0, 0, 1))

  expect_is(out, "constraint")
})

test_that("Item Category Constraint returns errors and warnings", {
  expect_error(itemCategoryConstraint(1, c(1, 2, 3), targetValues = c(1, 1, 1)),
               "'itemCategories' should be a factor.")
  expect_error(itemCategoryConstraint(2, factor(c(1, 2, 2)), "=", targetValues = c(1, 2), itemIDs = 1:2),
               "The length of 'itemCategories' and 'itemIDs' should be identical.")
  expect_error(itemCategoryConstraint(2, factor(c(1, 2, 2, 1)), "=", targetValues = 1),
               "The number of 'targetValues' should correspond with the number of levels in 'itemCategories'.")
  expect_error(itemCategoryConstraint(2:3, factor(c(1, 2, 2, 1)), "=", targetValues = c(1, 2),
                                      itemIDs = 1:4),
               "'nForms' should be a vector of length 1.")
  warns <- capture_warnings(out <- itemCategoryConstraint(2, factor(c(1, 1, 2, 2)), "=", targetValues = c(1, 2)))
  warns[[1]] <- "Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically."
})


test_that("Item Category Min Max and Threshold", {
  minMax <- itemCategoryRangeConstraint(2, factor(rep(1:2, 10)), range = cbind(min = c(3, 4), max = c(5, 6)), itemIDs = 1:20)
  expect_equal(minMax,
               combine2Constraints(itemCategoryMinConstraint(2, factor(rep(1:2, 10)), c(3, 4), itemIDs = 1:20),
                                   itemCategoryMaxConstraint(2, factor(rep(1:2, 10)), c(5, 6), itemIDs = 1:20)))
  expect_equal(minMax, itemCategoryDeviationConstraint(2, factor(rep(1:2, 10)), c(4, 5), c(1, 1), itemIDs = 1:20))


  max <- itemCategoryMaxConstraint(1, factor(c(1, 2, 3)), max = c(1, 1, 1), itemIDs = 1:3)
  expect_equal(max, itemCategoryConstraint(1, factor(c(1, 2, 3)), targetValues = c(1, 1, 1), itemIDs = 1:3))

  min <- itemCategoryMinConstraint(1, factor(c(1, 2, 3)), min = c(1, 1, 1), itemIDs = 1:3)
  expect_equal(min$A_binary[1, ], c(1, 0, 0))
  expect_equal(min$A_binary[2, ], c(0, 1, 0))
  expect_equal(min$A_binary[3, ], c(0, 0, 1))

  expect_is(minMax, "constraint")
})



test_that("Item Category Range returns errors", {
  expect_error(itemCategoryRangeConstraint(2, factor(rep(1:2, 10)), range = cbind(min = c(6, 4), max = c(5, 6))),
               "The values in the first column of 'range' should be smaller than the values in the second column of 'range'.")
  expect_error(itemCategoryRangeConstraint(2, factor(rep(1:2, 10)),
                                 range = c(min = c(4, 4), max = c(5, 6))),
               "itemCategories")
  expect_error(itemCategoryRangeConstraint(2, factor(rep(1:3, 10)),
                                 range = rbind(min = c(4, 4, 2), max = c(5, 6, 3))),
               "itemCategories")
  expect_error(itemCategoryRangeConstraint(2, factor(rep(1:2, 10)),
                                 range = rbind(min = c(4, 4, 2), max = c(5, 6, 3))),
               "itemCategories")
  expect_error(itemCategoryRangeConstraint(2, factor(rep(1:2, 10)),
                                 range = cbind(min = c(3, 4), max = c(5, 6)),
                                 info_text = c("too", "many", "strings")),
               "'info_text' should be a character string of length equal to to the number of levels in 'itemCategories'.")

})


