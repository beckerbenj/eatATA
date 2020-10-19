

test_that("item exclusion constraint", {
  tupl <- data.frame(i1 = c("I1", "I2"), i2 = c("I2", "I3"))
  out <- itemExclusionConstraint(nForms = 2, exclusionTuples = tupl, itemIDs = paste0("I", 1:3))
  expect_equal(out[1, ], c(1, 1, 0, 0, 0, 0, 0, -1, 1))
  expect_equal(out[4, ], c(0, 0, 0, 0, 1, 1, 0, -1, 1))

})

test_that("warning for exclusions on non existant items", {
  tupl <- data.frame(i1 = c("I1", "I2"), i2 = c("I2", "I4"))
  expect_warning(out <- itemExclusionConstraint(nForms = 2, exclusionTuples = tupl, itemIDs = paste0("I", 1:3)),
                 "The following item identifiers in the exclusion column are not item identifiers in the idCol column (check for correct sepPattern!): 'I4'", fixed = TRUE)
  expect_equal(dim(out), c(2, 9))
  expect_equal(out[1, ], c(1, 1, 0, 0, 0, 0, 0, -1, 1))
  expect_equal(out[2, ], c(0, 0, 0, 1, 1, 0, 0, -1, 1))
})


test_that("item exclusion constraint big item pool", {
  items <- eatATA::items
  exclusionTuples <- itemExclusionTuples(items, idCol = "Item_ID", exclusions = "exclusions", sepPattern = ", ")

  out <- itemExclusionConstraint(nForms = 14, exclusionTuples = exclusionTuples, itemIDs = items$Item_ID)
  expect_equal(as.character(class(out)), "dgCMatrix")
  expect_equal(dim(out), c(630, 1123))

})
