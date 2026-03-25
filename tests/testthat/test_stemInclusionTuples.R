
inclDF <- data.frame(ID = paste0("item_", 1:6),
                     stem = c(rep("stim_1", 3), "stim_3", "stim_4", "stim_3"),
                     stringsAsFactors = FALSE)

inclDF_tibble <- tibble::tibble(ID = paste0("item_", 1:6),
                     stem = c(rep("stim_1", 3), "stim_3", "stim_4", "stim_3"))
inclDF_dt <- data.table::data.table(ID = paste0("item_", 1:6),
                     stem = c(rep("stim_1", 3), "stim_3", "stim_4", "stim_3"),
                     stringsAsFactors = FALSE)

test_that("input errors", {
  expect_error(stemInclusionTuples(inclDF, idCol = "test", stemCol = "stem"),
               "'idCol' is not a column in 'items'.")

  expect_error(stemInclusionTuples(inclDF, idCol = "ID", stemCol = "test"),
               "'stemCol' is not a column in 'items'.")
})

test_that("works", {
  out <- stemInclusionTuples(inclDF, idCol = "ID", stemCol = "stem")
  expect_equal(out[, 1], paste0("item_", c(1, 1, 2, 4)))
  expect_equal(out[, 2], paste0("item_", c(2, 3, 3, 6)))
})


test_that("Github issue #1", {
  inclDF <- data.frame(ID = paste0("item_", 1:6),
                       stem = c(rep("stim_1", 3), "stim_3", "stim_3", "stim_3"),
                       stringsAsFactors = FALSE)

  out <- stemInclusionTuples(inclDF, idCol = "ID", stemCol = "stem")
  expect_equal(out[, 1], paste0("item_", c(1, 1, 2, 4, 4, 5)))
  expect_equal(out[, 2], paste0("item_", c(2, 3, 3, 5, 6, 6)))
})

test_that("function works as intended with tibbles or data tables input instead of 'items' data frames", {
  # tibbles
  out <- stemInclusionTuples(inclDF_tibble, idCol = "ID", stemCol = "stem")
  expect_equal(out[, 1], paste0("item_", c(1, 1, 2, 4)))
  expect_equal(out[, 2], paste0("item_", c(2, 3, 3, 6)))

  # data tables
  out <- stemInclusionTuples(inclDF_dt, idCol = "ID", stemCol = "stem")
  expect_equal(out[, 1], paste0("item_", c(1, 1, 2, 4)))
  expect_equal(out[, 2], paste0("item_", c(2, 3, 3, 6)))
})
