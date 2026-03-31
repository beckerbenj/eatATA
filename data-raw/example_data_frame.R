### example data (tibble and data table) to test for data frames ###

#' `test_analyzeBlockExclusion`
# items
items_tibble <- tibble::tibble(ID = paste0("item", 1:6),
                               itemValues = c(-4, -4, -2, -2, 20, 20))
items_dt <- data.table::data.table(ID = paste0("item", 1:6),
                                           itemValues = c(-4, -4, -2, -2, 20, 20), stringsAsFactors = FALSE)
# exclusionTuples
exclusionTuples_tibble <- tibble::tibble(v1 = c("item1", "item3"),
                                         v2 = c("item2", "item4"))
exclusionTuples_dt <- data.table::data.table(v1 = c("item1", "item3"),
                                             v2 = c("item2", "item4"), stringsAsFactors = FALSE)

analyzeBE <- list(items_tibble = items_tibble, items_dt= items_dt,
                  exclusionTuples_tibble = exclusionTuples_tibble,
                  exclusionTuples_dt = exclusionTuples_dt)

#save(analyzeBE, file = "tests/testthat/helper_test_analyzeBE.RData")
#load("tests/testthat/helper_test_analyzeBE.RData")

#' `test_analyzeComplexBlockExclusion`
# items_list
items1_tibble <- tibble::tibble(ID = paste0("item", 1:4), itemValues = c(-2, -4, 2, 4))
items2_tibble <- tibble::tibble(ID = paste0("item", 5:8), itemValues = c(-2, -4, 2, 4))
items1_dt <- data.table::data.table(ID = paste0("item", 1:4), itemValues = c(-2, -4, 2, 4), stringsAsFactors = FALSE)
items2_dt <- data.table::data.table(ID = paste0("item", 5:8), itemValues = c(-2, -4, 2, 4), stringsAsFactors = FALSE)
# exclusionTuples_list
suppressWarnings(exclusionTuples1_tibble <- tibble::tibble(v1 = c("item1", "item3"),
                                                           v2 = c("item2", "item5")))
suppressWarnings(exclusionTuples2_tibble <- tibble::tibble(v1 = c("item5", "item6"),
                                                           v2 = c("item3", "item7")))
suppressWarnings(exclusionTuples1_dt <- data.table::data.table(v1 = c("item1", "item3"),
                                                               v2 = c("item2", "item5"), stringsAsFactors = FALSE))
suppressWarnings(exclusionTuples2_dt <- data.table::data.table(v1 = c("item5", "item6"),
                                                               v2 = c("item3", "item7"), stringsAsFactors = FALSE))

analyzeCBE <- list(items1_tibble = items1_tibble, items2_tibble = items2_tibble,
                   items1_dt = items1_dt, items2_dt = items2_dt,
                   exclusionTuples1_tibble = exclusionTuples1_tibble, exclusionTuples2_tibble = exclusionTuples2_tibble,
                   exclusionTuples1_dt = exclusionTuples1_dt, exclusionTuples2_dt = exclusionTuples2_dt)

#save(analyzeCBE, file = "tests/testthat/helper_test_analyzeCBE.RData")
#load("tests/testthat/helper_test_analyzeCBE.RData")

#' `dummiesToFactor`

tdat_tibble <- tibble::tibble(ID = 1:3, d1=c(1, 0, 0), d2 = c(0, 1, 0), d3 = c(0, 0, 1))
tdat_m_tibble <- tibble::tibble(ID = 1:3, d1=c(1, NA, NA), d2 = c(NA, 1, NA), d3 = c(NA, NA, 1))
tdat_dt <- data.table::data.table(ID = 1:3, d1=c(1, 0, 0), d2 = c(0, 1, 0), d3 = c(0, 0, 1))
tdat_m_dt <- data.table::data.table(ID = 1:3, d1=c(1, NA, NA), d2 = c(NA, 1, NA), d3 = c(NA, NA, 1))

dummiesToFact <- list(tdat_tibble = tdat_tibble, tdat_m_tibble = tdat_m_tibble,
                      tdat_dt = tdat_dt, tdat_m_dt = tdat_m_dt)

#save(dummiesToFact, file = "tests/testthat/helper_test_dummiesToFactor.RData")
#load("tests/testthat/helper_test_dummiesToFactor.RData")

#' `itemExclusionConstraint` + `itemInclusionConstraint`
tupl_tibble <- tibble::tibble(i1 = c("I1", "I2"), i2 = c("I2", "I3"))
tupl_dt <- data.table::data.table(i1 = c("I1", "I2"), i2 = c("I2", "I3"))

itemExclusionCons <- list(tupl_tibble = tupl_tibble, tupl_dt = tupl_dt)

#save(itemExclusionCons, file = "tests/testthat/helper_test_itemExclusionConstraint.RData")
#load("tests/testthat/helper_test_itemExclusionConstraint.RData")

#' `matrixExclusionTuples`
exclDF_tibble <- tibble::tibble(a = c(0, 1, 0, 0),
                                b = c(1, 0, 0, 1),
                                c = c(0, 0, 0, 0),
                                d = c(0, 1, 0, 0))
rownames(exclDF_tibble) <- colnames(exclDF_tibble) <- paste0("item_", 1:4)
exclDF3_t <- exclDF2_t <- exclDF1_t <- exclDF_tibble
exclMatr_tibble <- as.matrix(exclDF_tibble)

exclDF_dt <- data.table::data.table(c(0, 1, 0, 0),
                                    c(1, 0, 0, 1),
                                    c(0, 0, 0, 0),
                                    c(0, 1, 0, 0))
rownames(exclDF_dt) <- colnames(exclDF_dt) <- paste0("item_", 1:4)
exclDF3_dt <- exclDF2_dt <- exclDF1_dt <- exclDF_dt
exclDF_dt_ <- as.data.frame(exclDF_dt)
rownames(exclDF_dt_) <- rownames(exclDF_dt)
exclMatr_dt <- as.matrix(exclDF_dt_)

matrixEclusionT <- list(exclDF_tibble = exclDF_tibble, exclMatr_tibble = exclMatr_tibble,
                        exclDF_dt = exclDF_dt, exclMatr_dt = exclMatr_dt)

#save(matrixEclusionT, file = "tests/testthat/helper_test_matrixExclusionTuples.RData")
#load("tests/testthat/helper_test_matrixExclusionTuples.RData")

#' `stemInclusionTuples`
inclDF_tibble <- tibble::tibble(ID = paste0("item_", 1:6),
                                stem = c(rep("stim_1", 3), "stim_3", "stim_4", "stim_3"))
inclDF_dt <- data.table::data.table(ID = paste0("item_", 1:6),
                                    stem = c(rep("stim_1", 3), "stim_3", "stim_4", "stim_3"),
                                    stringsAsFactors = FALSE)

stemInclusionTupl <- list (inclDF_tibble = inclDF_tibble, inclDF_dt = inclDF_dt)

#save(stemInclusionTupl, file = "tests/testthat/helper_test_stemInclusionTuples.RData")
#load("tests/testthat/helper_test_stemInclusionTuples.RData")

#' `inspectSolution`
items_tibble <- tibble::tibble(ID = paste0("item_", 1:10),
                               itemValues = c(-4, -4, -2, -2, -1, -1, 20, 20, 0, 0),
                               format = c(rep("mc", 5), rep("open", 5)))
items_dt <- data.table::data.table(ID = paste0("item_", 1:10),
                                   itemValues = c(-4, -4, -2, -2, -1, -1, 20, 20, 0, 0),
                                   format = c(rep("mc", 5), rep("open", 5)),
                                   stringsAsFactors = FALSE)

inspect_solution <- list(items_tibble = items_tibble, items_dt = items_dt)

#save(inspect_solution, file = "tests/testthat/helper_test_inspectSolution.RData")
#load("tests/testthat/helper_test_inspectSolution.RData")

#' `appendSolution`
items_tibble <- tibble::tibble(ID = paste0("item_", 1:10),
                               itemValues = c(-4, -4, -2, -2, -1, -1, 20, 20, 0, 0))
items_dt <- data.table::data.table(ID = paste0("item_", 1:10),
                                   itemValues = c(-4, -4, -2, -2, -1, -1, 20, 20, 0, 0),
                                   stringsAsFactors = FALSE)

append_solution <- list(items_tibble = items_tibble, items_dt = items_dt)

#save(append_solution, file = "tests/testthat/helper_test_appendSolution.RData")
#load("tests/testthat/helper_test_appendSolution.RData")

#' `itemTuples`
items_tibble <- tibble::tibble(ID = c("item1", "item2", "item3", "item4"),
                               exclusions = c("item2, item3", NA, NA, NA),
                               stringsAsFactors = FALSE)
items_dt <- data.table::data.table(ID = c("item1", "item2", "item3", "item4"),
                                   exclusions = c("item2, item3", NA, NA, NA),
                                   stringsAsFactors = FALSE)

item_tuples <- list(items_tibble = items_tibble, items_dt = items_dt)

#save(item_tuples, file = "tests/testthat/helper_test_itemTuples.RData")
#load("tests/testthat/helper_test_itemTuples.RData")



