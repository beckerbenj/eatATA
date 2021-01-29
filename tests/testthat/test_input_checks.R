
test_that("check_single_numeric", {
  expect_error(check_single_numeric(1:2, "vec"),
               "'vec' needs to be a numeric vector of length 1.")
  expect_error(check_single_numeric(c("a"), "vec"),
               "'vec' needs to be a numeric vector of length 1.")

  expect_silent(check_single_numeric(1, "vec"))
  expect_silent(check_single_numeric(1L, "vec"))
})

test_that("check_itemIDs_nItems", {
  expect_error(comb_itemIDs_nItems(nItems = 1:2),
               "'nItems' needs to be a numeric vector of length 1.")
  expect_error(comb_itemIDs_nItems(nItems = "a"),
               "'nItems' needs to be a numeric vector of length 1.")
  expect_error(comb_itemIDs_nItems(NULL),
               "Both arguments 'itemIDs' and 'nItems' are missing. Specify one of them.")
  expect_error(comb_itemIDs_nItems("item1", 2),
               "'itemIDs' and 'nItems' imply different item numbers.")
  expect_error(comb_itemIDs_nItems(mtcars),
               "'itemIDs' needs to be a vector.")
  expect_error(comb_itemIDs_nItems(c(1, 1)),
               "There are duplicate values in 'itemIDs'.")
  expect_warning(comb_itemIDs_nItems(NULL, 5),
               "Argument 'itemIDs' is missing. 'itemIDs' will be generated automatically.")
  expect_silent(out <- comb_itemIDs_nItems(c("item1", "item2")))
  expect_equal(out, 2)
})
