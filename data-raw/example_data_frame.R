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

save(analyzeBE, file = "N:/eatPackages/eatATA/tests/testthat/helper_test_analyzeBE.RData")
#load("N:/eatPackages/eatATA/tests/testthat/helper_test_analyzeBE.RData")

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

save(analyzeCBE, file = "N:/eatPackages/eatATA/tests/testthat/helper_test_analyzeCBE.RData")
#load("N:/eatPackages/eatATA/tests/testthat/helper_test_analyzeCBE.RData")

#' `dummiesToFactor`




#' `itemExclusionConstraint`

#' `itemInclusionConstraint`

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

save(matrixEclusionT, file = "N:/eatPackages/eatATA/tests/testthat/helper_test_matrixExclusionTuples.RData")
#load("N:/eatPackages/eatATA/tests/testthat/helper_test_matrixExclusionTuples.RData")

#' `stemInclusionTuples`

#' `inspectSolution`

#' `appendSolution`

#' `itemTuples`




