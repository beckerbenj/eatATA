
inclDF <- data.frame(ID = paste0("item_", 1:6),
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
