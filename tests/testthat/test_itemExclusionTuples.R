

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


