### example data (tibble and data table) to test for data frames ###

items_tibble <- tibble::tibble(ID = c("items1", "items2", "items3", "items4"),
                          exclusions = c("items2, items3", NA, NA, NA),
                          stringsAsFactors = FALSE)

items_data_table <- data.table::data.table(ID = c("items1", "items2", "items3", "items4"),
                                   exclusions = c("items2, items3", NA, NA, NA),
                                   stringsAsFactors = FALSE)

items_df <- data.frame(ID = c("items1", "items2", "items3", "items4"),
                 exclusions = c("items2, items3", NA, NA, NA),
                 stringsAsFactors = FALSE)

test_data <- list(items_df, items_tibble, items_data_table)


saveRDS(test_data, "N:/eatPackages/eatATA/tests/testthat/helper_testDataFrames.RDS")

### example tuples (should be data frame or matrix ###)
#tuples <- itemTuples(items = df, idCol = "ID", infoCol = "exclusions",
#                     sepPattern = ", ")

#assert_data_frame(tuples)
#assert_matrix(tuples)
