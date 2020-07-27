

items_small <- data.frame(ID = paste0("item", 1:6))

exclusionTuples <- data.frame(v1 = c("item1", "item3"),
                              v2 = c("item2", "item4"), stringsAsFactors = FALSE)

processedObj <- list(data.frame(ID = c("item1", "item4"),
                                    form_1 = c(1, 1),
                                    form_2 = c(0, 0),
                                    form_3 = c(0, 0)),
                     data.frame(ID = c("item2", "item3"),
                                    form_1 = c(0, 0),
                                    form_2 = c(1, 1),
                                    form_3 = c(0, 0)),
                     data.frame(ID = c("item5", "item6"),
                                    form_1 = c(0, 0),
                                    form_2 = c(0, 0),
                                    form_3 = c(1, 1))
                     )


test_that("analyze block exclusions", {
  out <- analyzeBlockExclusion(processedObj, idCol = "ID", exclusionTuples)
  expect_equal(names(out), c("Name 1", "Name 2"))
  expect_equal(dim(out), c(1, 2))
  expect_equal(as.character(out[1, ]), c("block 1", "block 2"))
})

test_that("other idcol name", {
  processedObj2 <- lapply(processedObj, function(x) {
    names(x)[1] <- "other_ID"
    x
  })

  out <- analyzeBlockExclusion(processedObj2, idCol = "other_ID", exclusionTuples)
  expect_equal(names(out), c("Name 1", "Name 2"))
  expect_equal(dim(out), c(1, 2))
  expect_equal(as.character(out[1, ]), c("block 1", "block 2"))
})

test_that("analyze block exclusions errors", {
  expect_error(analyzeBlockExclusion(mtcars, exclusionTuples), "'processedObj' has to be a list, not a data.frame.")
  exclusionTuples2 <- rbind(exclusionTuples, c("item1", "item7"))
  expect_error(analyzeBlockExclusion(processedObj, idCol = "ID", exclusionTuples2), "Currently analyzeBlockExclusion only works if item pool is depleted.")
  expect_error(analyzeBlockExclusion(processedObj, idCol = "lala", exclusionTuples2),
               "'idCol' must be a column name in the entries of 'processedObj'.")
})

