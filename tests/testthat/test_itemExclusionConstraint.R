

test_that("item exclusion constraint", {
  tupl <- data.frame(i1 = c("I1", "I2"), i2 = c("I2", "I3"))
  out <- itemExclusionConstraint(nForms = 2, exclusionTuples = tupl, itemIDs = paste0("I", 1:3))
  expect_equal(out$A_binary[1, ], c(1, 1, 0, 0, 0, 0))
  expect_equal(out$A_binary[4, ], c(0, 0, 0, 0, 1, 1))

})

test_that("warning for exclusions on non existant items", {
  tupl <- data.frame(i1 = c("I1", "I2"), i2 = c("I2", "I4"))
  expect_warning(out <- itemExclusionConstraint(nForms = 2, exclusionTuples = tupl, itemIDs = paste0("I", 1:3)),
                 "The following item identifiers in the exclusion column are not item identifiers in the idCol column (check for correct sepPattern!): 'I4'", fixed = TRUE)
  expect_equal(dim(out$A_binary), c(2, 6))
  expect_equal(out$A_binary[1, ], c(1, 1, 0, 0, 0, 0))
  expect_equal(out$A_binary[2, ], c(0, 0, 0, 1, 1, 0))
})


test_that("item exclusion constraint big item pool", {
  items <- eatATA::items
  exclusionTuples <- itemExclusionTuples(items, idCol = "Item_ID", exclusions = "exclusions", sepPattern = ", ")

  out <- itemExclusionConstraint(nForms = 14, exclusionTuples = exclusionTuples, itemIDs = items$Item_ID)
  expect_true(inherits(out$A_binary, "Matrix"))
  expect_equal(dim(out$A_binary), c(630, 1120))

})


test_that("item exclusion warnings", {
  items <- data.frame(ID = c("item1", "item2", "item3", "item4"),
                      exclusions = c("item2, item3", "item2,  item3", NA, NA),
                      stringsAsFactors = FALSE)
  expect_error(itemExclusionTuples(items = items, idCol = "ID", exclusions = "exclusions",
                                   sepPattern = ", "),
               "The following item is excluded from being with itself: item2", fixed = TRUE)

  items2 <- data.frame(ID = c("item1", "item2", "item3", "item4"),
                       exclusions = c("item2 , item3", "item4,  item3", NA, NA),
                       stringsAsFactors = FALSE)

  # carefully modified tests, as string sorting seems OS dependent!
  expect_warning(out <- itemExclusionTuples(items = items2, idCol = "ID", exclusions = "exclusions",
                                            sepPattern = ", "),
                 "The following item identifiers in the exclusion column are not item identifiers in the idCol column")
  expect_equal(out[1:3, 1], c("item1", "item1", "item2"))
  expect_equal(out[1:3, 2], c("item2 ", "item3", "item4"))
  expect_true(all(out[4, 1:2] %in% c(" item3", "item2")))
})


test_that("item exclusion tuples", {
  items <- data.frame(ID = c("item1", "item2", "item3", "item4"),
                      exclusions = c("item2, item3", NA, NA, NA),
                      stringsAsFactors = FALSE)

  out <- itemExclusionTuples(items = items, idCol = "ID", exclusions = "exclusions",
                             sepPattern = ", ")

  expect_equal(dim(out), c(2, 2))
  expect_equal(as.character(out[1, ]), c("item1", "item2"))
  expect_equal(as.character(out[2, ]), c("item1", "item3"))
})


test_that("item exclusion tuples other names and columnumbers", {
  items <- data.frame(v1 = c("item1", "item2", "item3", "item4"),
                      v2 = c("item2, item3", NA, NA, NA),
                      stringsAsFactors = FALSE)

  out <- itemExclusionTuples(items = items, idCol = "v1", exclusions = 2,
                             sepPattern = ", ")

  expect_equal(dim(out), c(2, 2))
  expect_equal(as.character(out[1, ]), c("item1", "item2"))
  expect_equal(as.character(out[2, ]), c("item1", "item3"))

  out <- itemExclusionTuples(items = items, idCol = 1, exclusions = "v2",
                             sepPattern = ", ")

  expect_equal(dim(out), c(2, 2))
  expect_equal(as.character(out[1, ]), c("item1", "item2"))
  expect_equal(as.character(out[2, ]), c("item1", "item3"))

})

test_that("item exclusion tuples big item pool", {
  items <- eatATA::items
  exclusionTuples <- itemExclusionTuples(items, idCol = 1, exclusions = 2, sepPattern = ", ")

  expect_equal(dim(exclusionTuples), c(45, 2))
})



