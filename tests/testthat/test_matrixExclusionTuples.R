
exclDF <- data.frame(c(0, 1, 0, 0),
                     c(1, 0, 0, 1),
                     c(0, 0, 0, 0),
                     c(0, 1, 0, 0))
rownames(exclDF) <- colnames(exclDF) <- paste0("item_", 1:4)

exclDF3 <- exclDF2 <- exclDF1 <- exclDF
exclMatr <- as.matrix(exclDF)

#exclDF_tibble <- tibble::tibble(c(0, 1, 0, 0),
#                                c(1, 0, 0, 1),
#                                c(0, 0, 0, 0),
#                                c(0, 1, 0, 0))
#rownames(exclDF_tibble) <- colnames(exclDF_tibble) <- paste0("item_", 1:4)
#exclDF3_t <- exclDF2_t <- exclDF1_t <- exclDF_tibble
#exclMatr_tibble <- as.matrix(exclDF_tibble)

exclDF_dt <- data.table::data.table(c(0, 1, 0, 0),
                                    c(1, 0, 0, 1),
                                    c(0, 0, 0, 0),
                                    c(0, 1, 0, 0))
rownames(exclDF_dt) <- colnames(exclDF_dt) <- paste0("item_", 1:4)
exclDF3_dt <- exclDF2_dt <- exclDF1_dt <- exclDF_dt
exclMatr_dt <- as.matrix(exclDF_dt)

test_that("matrixExclusionTuples errors", {
  rownames(exclDF1)[1] <- "item_x"
  expect_error(matrixExclusionTuples(exclDF1), "'exclMatrix' needs to have symmetrical row and column names.")

  exclDF2[3, 4] <- 1
  expect_error(matrixExclusionTuples(exclDF2), "'exclMatrix' needs to be symmetrical.")

  exclDF3[3, 4] <- 3
  expect_error(matrixExclusionTuples(exclDF3), "'exclMatrix' must only contain 0 and 1.")
})

test_that("matrixExclusionTuples works", {
  out <- matrixExclusionTuples(exclDF)
  colnames(out) <- NULL
  expect_equal(dim(out), c(2, 2))
  expect_equal(out[1, ], c("item_1", "item_2"))
  expect_equal(out[2, ], c("item_2", "item_4"))

  out2 <- matrixExclusionTuples(exclMatr)
  colnames(out2) <- NULL
  expect_equal(out, out2)
})

test_that("function works as intended with tibbles or data tables input instead of 'exclMatrix' data frames", {
  # tibbles
  out <- matrixExclusionTuples(exclDF_dt)
  colnames(out) <- NULL
  expect_equal(dim(out), c(2, 2))
  expect_equal(out[1, ], c("item_1", "item_2"))
  expect_equal(out[2, ], c("item_2", "item_4"))

  out2 <- matrixExclusionTuples(exclMatr_dt)
  colnames(out2) <- NULL
  expect_equal(out, out2)

  # data tables

})
