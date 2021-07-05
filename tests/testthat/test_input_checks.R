test_that("check_type", {
  expect_error(check_type(vec = 1:2, type = "character"),
               "'vec' should be a character vector.")
  expect_error(check_type(vec = c("a")),
               "'vec' should be a numeric vector.")

  expect_error(check_type(c("a"), vec = TRUE),
               "'', 'vec' should be a numeric vector.")

  expect_invisible(check_type(1:2), TRUE)
  expect_invisible(check_type(1:2), TRUE)

  expect_false(check_type(vec = 1:2, type = "character", stop = FALSE))
})


test_that("check_length", {
  expect_error(check_length(vec = 1, length = 2),
               "'vec' should be a vector of length 2.")
  expect_error(check_length(vec = c("a", "b")),
               "'vec' should be a vector of length 1.")
  expect_silent(check_length(vec = c("a", "b"), length = 2))

  goal <- 2
  vec <-  c("a", "b")
  expect_silent(check_length(vec, length = goal))

  expect_error(check_length(vec = 1, c("a"), length = 2),
               paste0("'vec', 'c(\"a\")' should be a vector of length 2."), fixed = TRUE)

  expect_invisible(check_length(vec = 1, c("a", "b"), length = 2, stop = FALSE),
                   c(FALSE, TRUE))
  expect_invisible(check_length(1L), TRUE)

  expect_false(check_length(vec = 1, length = 2, stop = FALSE))
})



test_that("check_nItems_itemValues_itemIDs works", {
  expect_error(check_nItems_itemValues_itemIDs(nItems = 1:2),
               "'nItems' should be a vector of length 1.")
  expect_error(check_nItems_itemValues_itemIDs(nItems = "a"),
               "'nItems' should be a numeric vector")
  expect_error(check_nItems_itemValues_itemIDs(NULL),
               "Impossible to infer the number of items in the pool. Specify either 'itemIDs' or 'nItems' or 'itemValues'")
  expect_error(check_nItems_itemValues_itemIDs(2, "item1"),
               "The length of 'itemIDs' and 'nItems' should correspond.")
  expect_error(check_nItems_itemValues_itemIDs(2, NULL, 1),
               "The length of 'itemValues' and 'nItems' should correspond.")
  expect_error(check_nItems_itemValues_itemIDs(NULL, "item1", 1:2),
               "The length of 'itemIDs' and 'itemValues' should correspond.")
  expect_error(check_nItems_itemValues_itemIDs(mtcars),
               "'nItems' should be a numeric vector.")
  expect_error(check_nItems_itemValues_itemIDs(NULL, c(1, 1)),
               "There are duplicate values in 'itemIDs'.")

  expect_warning(out1 <- check_nItems_itemValues_itemIDs(5),
                 "Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.")
  expect_warning(out2 <- check_nItems_itemValues_itemIDs(NULL, NULL, 1:5),
                 "Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.")


  expect_equal(out1[1:2], out2[1:2])
})



test_that("whichItemstoNumeric", {
  expect_equal(whichItemsToNumeric(c("item3"), paste0("item", 1:5)), 3)
  expect_equal(whichItemsToNumeric(c("item5", "item2"), paste0("item", 1:5)), c(5, 2))

  expect_equal(whichItemsToNumeric(c(3, 4, 1), paste0("item", 1:5)), c(3, 4, 1))
  expect_equal(whichItemsToNumeric(NULL, paste0("item", 1:5)), 1:5)
})

test_that("whichItemstoNumeric errors", {
  expect_error(whichItemsToNumeric(c("item6"), paste0("item", 1:5)),
               "The following item IDs are in 'whichItem' but not in 'itemIDs': item6")
  expect_error(whichItemsToNumeric(c("item6"), NULL),
               "item IDs supplied to 'whichItems' but not to 'itemIDs'.")
  expect_error(whichItemsToNumeric(c(3, 6, 1), paste0("item", 1:5)),
               "Some values in 'whichItems' are out of range. That is, higher than the length of 'itemIDs'.")
})

