
test_that("input checks, errors", {
  expect_error(itemTuples(items = items_mini, idCol = "id", infoCol = "format", sepPattern = ", "),
               "'idCol' is not a column in 'items'.")
  expect_error(itemTuples(items = items_mini, idCol = "item", infoCol = "Format", sepPattern = ", "),
               "'infoCol' is not a column in 'items'.")

  items <- data.frame(ID = c("item1", "item2", "item3", "item4"),
                      exclusions = c("item2, item3", "item2,  item3", NA, NA),
                      stringsAsFactors = FALSE)
  expect_error(itemTuples(items = items, idCol = "ID", infoCol = "exclusions",
                          sepPattern = ", "),
               "The following item is paired with itself: item2", fixed = TRUE)
})


test_that("item tuples warnings", {
  items2 <- data.frame(ID = c("item1", "item2", "item3", "item4"),
                       exclusions = c("item2 , item3", "item4,  item3", NA, NA),
                       stringsAsFactors = FALSE)

  # carefully modified tests, as string sorting seems OS dependent!
  expect_warning(out <- itemTuples(items = items2, idCol = "ID", infoCol = "exclusions",
                                   sepPattern = ", "),
                 "The following item identifiers in the input column are not item identifiers in the 'idCol' column")
  expect_equal(out[1:3, 1], c("item1", "item1", "item2"))
  expect_equal(out[1:3, 2], c("item2 ", "item3", "item4"))
  expect_true(all(out[4, 1:2] %in% c(" item3", "item2")))
})

test_that("item tuples with numeric ID", {
  out <- itemTuples(items_pilot, idCol = "item", infoCol = "exclusions", sepPattern = ", ")
  expect_equal(out[1, ], c("3", "76"))
  expect_equal(out[43, ], c("82", "97"))
})

test_that("item tuples", {
  items <- data.frame(ID = c("item1", "item2", "item3", "item4"),
                      exclusions = c("item2, item3", NA, NA, NA),
                      stringsAsFactors = FALSE)

  out <- itemTuples(items = items, idCol = "ID", infoCol = "exclusions",
                    sepPattern = ", ")

  expect_equal(dim(out), c(2, 2))
  expect_equal(as.character(out[1, ]), c("item1", "item2"))
  expect_equal(as.character(out[2, ]), c("item1", "item3"))
})


test_that("item tuples other names and columnumbers", {
  items <- data.frame(v1 = c("item1", "item2", "item3", "item4"),
                      v2 = c("item2, item3", NA, NA, NA),
                      stringsAsFactors = FALSE)

  out <- itemTuples(items = items, idCol = "v1", infoCol = 2,
                    sepPattern = ", ")

  expect_equal(dim(out), c(2, 2))
  expect_equal(as.character(out[1, ]), c("item1", "item2"))
  expect_equal(as.character(out[2, ]), c("item1", "item3"))

  out <- itemTuples(items = items, idCol = 1, infoCol = "v2",
                    sepPattern = ", ")

  expect_equal(dim(out), c(2, 2))
  expect_equal(as.character(out[1, ]), c("item1", "item2"))
  expect_equal(as.character(out[2, ]), c("item1", "item3"))

})

test_that("item tuples big item pool", {
  items <- eatATA::items_vera
  itemTuples <- itemTuples(items, idCol = 1, infoCol = 2, sepPattern = ", ")

  expect_equal(dim(itemTuples), c(45, 2))
})




