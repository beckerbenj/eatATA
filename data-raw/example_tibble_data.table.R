### example data (tibble and data table) to test for data frames ###
library(tibble)
library(data.table)

#' `test_analyzeBlockExclusion`
# items
items_tibble <- tibble(ID = paste0("item", 1:6),
                       itemValues = c(-4, -4, -2, -2, 20, 20))
items_dt <- data.table(ID = paste0("item", 1:6),
                       itemValues = c(-4, -4, -2, -2, 20, 20), stringsAsFactors = FALSE)
# exclusionTuples
exclusionTuples_tibble <- tibble(v1 = c("item1", "item3"),
                                 v2 = c("item2", "item4"))
exclusionTuples_dt <- data.table(v1 = c("item1", "item3"),
                                 v2 = c("item2", "item4"), stringsAsFactors = FALSE)

#save(items_tibble, items_dt, exclusionTuples_tibble, exclusionTuples_dt, file = "tests/testthat/helper_analyzeBlockExclusion.RData")
#load("tests/testthat/helper_analyzeBlockExclusion.RData")


#' `test_analyzeComplexBlockExclusion`
# items_list
items1_tibble <- tibble(ID = paste0("item", 1:4), itemValues = c(-2, -4, 2, 4))
items2_tibble <- tibble(ID = paste0("item", 5:8), itemValues = c(-2, -4, 2, 4))
items1_dt <- data.table(ID = paste0("item", 1:4), itemValues = c(-2, -4, 2, 4), stringsAsFactors = FALSE)
items2_dt <- data.table(ID = paste0("item", 5:8), itemValues = c(-2, -4, 2, 4), stringsAsFactors = FALSE)
# exclusionTuples_list
suppressWarnings(exclusionTuples1_tibble <- tibble(v1 = c("item1", "item3"),
                                                   v2 = c("item2", "item5")))
suppressWarnings(exclusionTuples2_tibble <- tibble(v1 = c("item5", "item6"),
                                                   v2 = c("item3", "item7")))
suppressWarnings(exclusionTuples1_dt <- data.table(v1 = c("item1", "item3"),
                                                   v2 = c("item2", "item5"), stringsAsFactors = FALSE))
suppressWarnings(exclusionTuples2_dt <- data.table(v1 = c("item5", "item6"),
                                                   v2 = c("item3", "item7"), stringsAsFactors = FALSE))

#save(items1_tibble, items2_tibble, items1_dt, items2_dt, exclusionTuples1_tibble,
#     exclusionTuples2_tibble, exclusionTuples1_dt, exclusionTuples2_dt,
#     file = "tests/testthat/helper_analyzeComplexBlockExclusion.RData")
#load("tests/testthat/helper_analyzeComplexBlockExclusion.RData")


#' `dummiesToFactor`
tdat_tibble <- tibble(ID = 1:3, d1=c(1, 0, 0), d2 = c(0, 1, 0), d3 = c(0, 0, 1))
tdat_m_tibble <- tibble(ID = 1:3, d1=c(1, NA, NA), d2 = c(NA, 1, NA), d3 = c(NA, NA, 1))
tdat_dt <- data.table(ID = 1:3, d1=c(1, 0, 0), d2 = c(0, 1, 0), d3 = c(0, 0, 1))
tdat_m_dt <- data.table(ID = 1:3, d1=c(1, NA, NA), d2 = c(NA, 1, NA), d3 = c(NA, NA, 1))

#save(tdat_tibble, tdat_m_tibble, tdat_dt, tdat_m_dt, file = "tests/testthat/helper_dummiesToFactor.RData")
#load("tests/testthat/helper_dummiesToFactor.RData")


#' `itemExclusionConstraint` + `itemInclusionConstraint`
tupl_tibble <- tibble(i1 = c("I1", "I2"), i2 = c("I2", "I3"))
tupl_dt <- data.table(i1 = c("I1", "I2"), i2 = c("I2", "I3"))

#save(tupl_tibble, tupl_dt, file = "tests/testthat/helper_itemExclusionConstraint.RData")
#load("tests/testthat/helper_itemExclusionConstraint.RData")


#' `matrixExclusionTuples`
exclDF_tibble <- tibble(a = c(0, 1, 0, 0),
                        b = c(1, 0, 0, 1),
                        c = c(0, 0, 0, 0),
                        d = c(0, 1, 0, 0))
rownames(exclDF_tibble) <- colnames(exclDF_tibble) <- paste0("item_", 1:4)
exclDF3_t <- exclDF2_t <- exclDF1_t <- exclDF_tibble
exclMatr_tibble <- as.matrix(exclDF_tibble)

exclDF_dt <- data.table(c(0, 1, 0, 0),
                        c(1, 0, 0, 1),
                        c(0, 0, 0, 0),
                        c(0, 1, 0, 0))
rownames(exclDF_dt) <- colnames(exclDF_dt) <- paste0("item_", 1:4)
exclDF3_dt <- exclDF2_dt <- exclDF1_dt <- exclDF_dt
exclDF_dt_ <- as.data.frame(exclDF_dt)
rownames(exclDF_dt_) <- rownames(exclDF_dt)
exclMatr_dt <- as.matrix(exclDF_dt_)

#save(exclDF_tibble, exclMatr_tibble, exclDF_dt, exclMatr_dt, file = "tests/testthat/helper_matrixExclusionTuples.RData")
#load("tests/testthat/helper_matrixExclusionTuples.RData")

#' `stemInclusionTuples`
inclDF_tibble <- tibble(ID = paste0("item_", 1:6),
                        stem = c(rep("stim_1", 3), "stim_3", "stim_4", "stim_3"))
inclDF_dt <- data.table(ID = paste0("item_", 1:6),
                        stem = c(rep("stim_1", 3), "stim_3", "stim_4", "stim_3"),
                        stringsAsFactors = FALSE)

#save(inclDF_tibble, inclDF_dt, file = "tests/testthat/helper_stemInclusionTuples.RData")
#load("tests/testthat/helper_stemInclusionTuples.RData")

#' `inspectSolution`
items_tibble <- tibble(ID = paste0("item_", 1:10),
                       itemValues = c(-4, -4, -2, -2, -1, -1, 20, 20, 0, 0),
                       format = c(rep("mc", 5), rep("open", 5)))
items_dt <- data.table(ID = paste0("item_", 1:10),
                       itemValues = c(-4, -4, -2, -2, -1, -1, 20, 20, 0, 0),
                       format = c(rep("mc", 5), rep("open", 5)),
                       stringsAsFactors = FALSE)

#save(items_tibble, items_dt, file = "tests/testthat/helper_inspectSolution.RData")
#load("tests/testthat/helper_inspectSolution.RData")

#' `appendSolution`
items_tibble <- tibble(ID = paste0("item_", 1:10),
                       itemValues = c(-4, -4, -2, -2, -1, -1, 20, 20, 0, 0))
items_dt <- data.table(ID = paste0("item_", 1:10),
                       itemValues = c(-4, -4, -2, -2, -1, -1, 20, 20, 0, 0),
                       stringsAsFactors = FALSE)

#save(items_tibble, items_dt, file = "tests/testthat/helper_appendSolution.RData")
#load("tests/testthat/helper_appendSolution.RData")

#' `itemTuples`
items_tibble <- tibble(ID = c("item1", "item2", "item3", "item4"),
                       exclusions = c("item2, item3", NA, NA, NA))
items_dt <- data.table(ID = c("item1", "item2", "item3", "item4"),
                       exclusions = c("item2, item3", NA, NA, NA),
                       stringsAsFactors = FALSE)

#save(items_tibble, items_dt, file = "tests/testthat/helper_itemTuples.RData")
#load("tests/testthat/helper_itemTuples.RData")



