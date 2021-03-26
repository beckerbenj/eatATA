items1 <- data.frame(ID = paste0("item", 1:4), itemValues = c(-2, -4, 2, 4), stringsAsFactors = FALSE)
items2 <- data.frame(ID = paste0("item", 5:8), itemValues = c(-2, -4, 2, 4), stringsAsFactors = FALSE)

suppressWarnings(exclusionTuples1 <- data.frame(v1 = c("item1", "item3"),
                              v2 = c("item2", "item5"), stringsAsFactors = FALSE))
suppressWarnings(exclusionTuples2 <- data.frame(v1 = c("item5", "item6"),
                               v2 = c("item3", "item7"), stringsAsFactors = FALSE))

suppressWarnings(excl1 <- itemExclusionConstraint(nForms = 2, exclusionTuples1, itemIDs = items1$ID))
suppressWarnings(excl2 <- itemExclusionConstraint(nForms = 2, exclusionTuples2, itemIDs = items2$ID))
usage1 <- itemUsageConstraint(nForms = 2, nItems = 4, operator = "=", targetValue = 1, itemIDs = items1$ID)
perForm1 <- itemsPerFormConstraint(nForms = 2, nItems = 4, operator = "=", targetValue = 2, itemIDs = items1$ID)

target1 <- minimaxObjective(nForms = 2, itemValues = items1$itemValues,
                               targetValue = 0, itemIDs = items1$ID)

usage2 <- itemUsageConstraint(nForms = 2, nItems = 4, operator = "=", targetValue = 1, itemIDs = items2$ID)
perForm2 <- itemsPerFormConstraint(nForms = 2, nItems = 4, operator = "=", targetValue = 2, itemIDs = items2$ID)

target2 <- minimaxObjective(nForms = 2, itemValues = items2$itemValues,
                             targetValue = 0, itemIDs = items2$ID)

#suppressMessages(sol1 <- useSolver(allConstraints = list(usage1, excl1, target1, perForm1),
#                                  solver = "GLPK", formNames = "block"))
#suppressMessages(sol2 <- useSolver(allConstraints = list(usage2, excl2, target2, perForm2),
#                                   solver = "GLPK", formNames = "block"))
#save(sol1, sol2, file = "tests/testthat/helper_complexBlockExclusions.RData")
#load("tests/testthat/helper_complexBlockExclusions.RData")
load("helper_complexBlockExclusions.RData")

test_that("analyze block exclusions", {
  out <- analyzeComplexBlockExclusion(solverOut_list = list(sol1, sol2),
                                      items_list = list(items1, items2),
                                      idCol = 1,
                                      exclusionTuples_list = list(exclusionTuples1, exclusionTuples2))

  expect_equal(names(out), c("Name 1", "Name 2"))
  expect_equal(dim(out), c(3, 2))
  expect_equal(as.character(out[1, ]), c("block_1", "block_2"))
  expect_equal(as.character(out[2, ]), c("block_2", "block_4"))
  expect_equal(as.character(out[3, ]), c("block_3", "block_4"))
})
