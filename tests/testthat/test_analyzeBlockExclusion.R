

items_small <- data.frame(ID = paste0("item", 1:6),
                          itemValues = c(-4, -4, -2, -2, 20, 20), stringsAsFactors = FALSE)

exclusionTuples <- data.frame(v1 = c("item1", "item3"),
                              v2 = c("item2", "item4"), stringsAsFactors = FALSE)
excl <- itemExclusionConstraint(nForms = 3, exclusionTuples, itemIDs = items_small$ID)
usage <- itemUsageConstraint(nForms = 3, nItems = 6, operator = "=", targetValue = 1)
perForm <- itemsPerFormConstraint(nForms = 3, nItems = 6, operator = "=", targetValue = 2)

target <- itemTargetConstraint(nForms = 3, nItems = 6,
                               itemValues = items_small$itemValues,
                               targetValue = 0)

suppressMessages(sol <- useSolver(allConstraints = list(usage, excl, target, perForm),
                                  nForms = 3, itemIDs = items_small$ID, solver = "GLPK", verbose = FALSE))


test_that("analyze block exclusions", {
  out <- analyzeBlockExclusion(sol, items = items_small, idCol = "ID", exclusionTuples)

  expect_equal(names(out), c("Name 1", "Name 2"))
  expect_equal(dim(out), c(2, 2))
  expect_equal(as.character(out[2, ]), c("block_1", "block_2"))
  expect_equal(as.character(out[1, ]), c("block_1", "block_3"))
})

test_that("other idcol name", {
  items_small2 <- items_small
  names(items_small2)[1] <- "other_ID"

  out <- analyzeBlockExclusion(sol, items = items_small2, idCol = "other_ID", exclusionTuples)
  expect_equal(names(out), c("Name 1", "Name 2"))
  expect_equal(dim(out), c(2, 2))
  expect_equal(as.character(out[2, ]), c("block_1", "block_2"))
})

test_that("analyze block exclusions errors", {
  expect_error(analyzeBlockExclusion(sol, items = as.list(items_small), idCol = "ID", exclusionTuples),
               "'items' must be a data.frame.")
  expect_error(analyzeBlockExclusion(sol, items = items_small, idCol = "lala", exclusionTuples),
               "'idCol' must be a column name in 'items'.")
})

test_that("block exclusions without item pool depletion", {
  exclusionTuples2 <- rbind(exclusionTuples, c("item1", "item7"))
  out <- analyzeBlockExclusion(sol, items = items_small, idCol = "ID", exclusionTuples2)

  expect_equal(names(out), c("Name 1", "Name 2"))
  expect_equal(dim(out), c(2, 2))
  expect_equal(as.character(out[2, ]), c("block_1", "block_2"))
  expect_equal(as.character(out[1, ]), c("block_1", "block_3"))
})
