
test_that("item exclusion errors", {
  items <- data.frame(ID = c("item1", "item2", "item3", "item4"),
                      exclusions = c("item2, item3", "item2,  item3", NA, NA))
  expect_error(itemExclusionTuples(items = items, idCol = "ID", exclusions = "exclusions",
                             sepPattern = ", "),
               "The following item identifiers in the exclusion column are not item identifiers in the idCol column (check for correct sepPattern!):' item3'", fixed = TRUE)

  items2 <- data.frame(ID = c("item1", "item2", "item3", "item4"),
                      exclusions = c("item2 , item3", "item2,  item3", NA, NA))
  expect_error(itemExclusionTuples(items = items2, idCol = "ID", exclusions = "exclusions",
                                   sepPattern = ", "),
               "The following item identifiers in the exclusion column are not item identifiers in the idCol column (check for correct sepPattern!):' item3', 'item2 ", fixed = TRUE)
})


test_that("item exclusion tuples", {
  items <- data.frame(ID = c("item1", "item2", "item3", "item4"),
                        exclusions = c("item2, item3", NA, NA, NA))

  out <- itemExclusionTuples(items = items, idCol = "ID", exclusions = "exclusions",
                       sepPattern = ", ")

  expect_equal(dim(out), c(2, 2))
  expect_equal(as.character(out[1, ]), c("item1", "item2"))
  expect_equal(as.character(out[2, ]), c("item1", "item3"))
})


test_that("item exclusion tuples other names", {
  items <- data.frame(v1 = c("item1", "item2", "item3", "item4"),
                      v2 = c("item2, item3", NA, NA, NA))

  out <- itemExclusionTuples(items = items, idCol = "v1", exclusions = "v2",
                             sepPattern = ", ")

  expect_equal(dim(out), c(2, 2))
  expect_equal(as.character(out[1, ]), c("item1", "item2"))
  expect_equal(as.character(out[2, ]), c("item1", "item3"))

})

test_that("item exclusion tuples big item pool", {
  items <- eatATA::items
  exclusionTuples <- itemExclusionTuples(items, idCol = "Item_ID", exclusions = "exclusions", sepPattern = ", ")

  expect_equal(dim(exclusionTuples), c(45, 2))
})


