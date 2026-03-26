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
load("N:/eatPackages/eatATA/tests/testthat/helper_test_analyzeCBE.RData")


#' `dummiesToFactor`




#' `itemExclusionConstraint`

#' `itemInclusionConstraint`

#' `matrixExclusionTuples`

#' `stemInclusionTuples`

#' `inspectSolution`

#' `appendSolution`

#' `itemTuples`


















test_data <- list(items_df, items_tibble, items_data_table)

saveRDS(test_data, "N:/eatPackages/eatATA/tests/testthat/helper_testDataFrames.RDS")

### example tuples (should be data frame or matrix ###)
#tuples <- itemTuples(items = df, idCol = "ID", infoCol = "exclusions",
#                     sepPattern = ", ")

#assert_data_frame(tuples)
#assert_matrix(tuples)
