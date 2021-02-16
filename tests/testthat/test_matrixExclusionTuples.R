
exclDF <- data.frame(c(0, 1, 0, 0),
                          c(1, 0, 0, 1),
                          c(0, 0, 0, 0),
                          c(0, 1, 0, 0))
rownames(exclDF) <- colnames(exclDF) <- paste0("item_", 1:4)

exclDF3 <- exclDF2 <- exclDF1 <- exclDF
exclMatr <- as.matrix(exclDF)

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
