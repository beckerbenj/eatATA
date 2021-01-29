

items_small <- data.frame(ID = paste0("item", 1:6),
                          itemValues = c(-4, -4, -2, -2, 20, 20), stringsAsFactors = FALSE)

exclusionTuples <- data.frame(v1 = c("item1", "item3"),
                              v2 = c("item2", "item4"), stringsAsFactors = FALSE)
exclusionTuples_mat <- as.matrix(exclusionTuples)
excl <- itemExclusionConstraint(nForms = 3, exclusionTuples, itemIDs = items_small$ID)
usage <- itemUsageConstraint(nForms = 3, nItems = 6, operator = "=", targetValue = 1, itemIDs = items_small$ID)
perForm <- itemsPerFormConstraint(nForms = 3, nItems = 6, operator = "=", targetValue = 2, itemIDs = items_small$ID)

target <- minimaxConstraint(nForms = 3, itemValues = items_small$itemValues,
                               targetValue = 0, itemIDs = items_small$ID)

suppressMessages(sol <- useSolver(allConstraints = list(usage, excl, target, perForm),
                                  solver = "GLPK", verbose = FALSE, formNames = "block"))
#save(sol, file = "tests/testthat/helper_BlockExclusions.RData")
#load("tests/testthat/helper_BlockExclusions.RData")
load("helper_BlockExclusions.RData")

test_that("analyze block exclusions", {
  out <- analyzeBlockExclusion(sol, items = items_small, idCol = "ID", exclusionTuples)

  expect_equal(names(out), c("Name 1", "Name 2"))
  expect_equal(dim(out), c(2, 2))
  expect_equal(as.character(out[2, ]), c("block_1", "block_2"))
  expect_equal(as.character(out[1, ]), c("block_1", "block_3"))
})

test_that("analyze block exclusions if exclusions as matrix", {
  out <- analyzeBlockExclusion(sol, items = items_small, idCol = "ID", exclusionTuples_mat)

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
               "'idCol' is not a column in 'items'.")
  expect_error(analyzeBlockExclusion(sol, items = items_small, idCol = "ID", exclusionTuples[, c(1, 1, 2)]),
               "'exclusionTuples' must have two columns.")
  expect_error(analyzeBlockExclusion(sol, items = items_small, idCol = "ID", exclusionTuples = "a"),
               "'exclusionTuples' must be a data.frame.")
  sol$solution_found <- FALSE
  sol$solution <- rep(0, length(sol$solution))
  expect_error(analyzeBlockExclusion(sol, items = items_small, idCol = "ID", exclusionTuples),
               "'solverOut' does not contain a feasible solution.")
})

test_that("block exclusions without item pool depletion", {
  exclusionTuples2 <- rbind(exclusionTuples, c("item1", "item7"))
  out <- analyzeBlockExclusion(sol, items = items_small, idCol = "ID", exclusionTuples2)

  expect_equal(names(out), c("Name 1", "Name 2"))
  expect_equal(dim(out), c(2, 2))
  expect_equal(as.character(out[2, ]), c("block_1", "block_2"))
  expect_equal(as.character(out[1, ]), c("block_1", "block_3"))
})
