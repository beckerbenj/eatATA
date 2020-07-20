

test_that("item exclusion constraint", {
  tupl <- data.frame(i1 = c("I1", "I2"), i2 = c("I2", "I3"))
  out <- itemExclusionConstraint(nForms = 2, exclusionTuples = tupl, itemIDs = paste0("I", 1:3))
  expect_equal(out[1, ], c(1, 1, 0, 0, 0, 0, 0, -1, 1))
  expect_equal(out[4, ], c(0, 0, 0, 0, 1, 1, 0, -1, 1))

})


test_that("item exclusion constraint big item pool", {
  items <- eatATA::items
  exclusionTuples <- itemExclusionTuples(items, idCol = "Item_ID", exclusions = "exclusions", sepPattern = ", ")

  out <- itemExclusionConstraint(nForms = 14, exclusionTuples = exclusionTuples, itemIDs = items$Item_ID)
  expect_equal(as.character(class(out)), "dgCMatrix")
  expect_equal(dim(out), c(630, 1123))

})
