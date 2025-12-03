test_that("maxObjective works", {
  nItems <- 20
  nForms <- 1
  itemValues <- c(rep(0, nItems)[-c(1:2)], rep(10, 2))

  testLength <- itemsPerFormConstraint(nForms, targetValue = 2, itemIDs = 1:nItems)
  objective <- maxObjective(nForms, itemValues, itemIDs = 1:nItems)
  allConstraints <- combine2Constraints(testLength, objective)
  solution <- useSolver(allConstraints, solver = "GL", verbose = FALSE)
  expect_equal(solution$item_matrix$form_1[19:20], c(1, 1))
  expect_equal(solution$solution[nItems + 1], sum(itemValues))
})



test_that("minObjective works", {
  nItems <- 20
  nForms <- 1
  itemValues <- seq_len(nItems)

  testLength <- itemsPerFormConstraint(nForms, nItems, operator = ">=", targetValue = 3, itemIDs = 1:nItems)
  objective <- minObjective(nForms, itemValues, itemIDs = 1:nItems)
  allConstraints <- combine2Constraints(testLength, objective)
  solution <- useSolver(allConstraints, solver = "GL", verbose = FALSE)
  expect_equal(solution$item_matrix$form_1[1:3], c(1, 1, 1))
  expect_equal(solution$solution[nItems + 1], sum(itemValues[1:3]))
})


set.seed(145)
nItems <- 50
nForms <- 3
itemValues <- seq(1, 15, length.out = nItems)
itemCategory <- factor(sample(1:3, size = nItems, replace = TRUE))
itemsPerForm <- floor(nItems/nForms) - 4

testLength <- itemsPerFormConstraint(nForms, operator = "=", targetValue = itemsPerForm, itemIDs = 1:nItems)
noOverlap <- itemUsageConstraint(nForms, nItems, itemIDs = 1:nItems)
target <- computeTargetValues(itemCategory, nForms, testLength = itemsPerForm)
catConstraints <- itemCategoryRangeConstraint(nForms, itemCategory, target, itemIDs = 1:nItems)


test_that("maximinObjective works", {
  objective <- maximinObjective(nForms, itemValues, allowedDeviation = 0.05, itemIDs = 1:nItems)
  allConstraints <- combineConstraints(testLength, objective, noOverlap)
  solution <- useSolver(allConstraints, solver = "GL", verbose = FALSE)
  expect_equal(unname(rowSums(solution$item_matrix)),
               rep(c(0, 1), c(nItems - nForms * itemsPerForm, nForms * itemsPerForm)))
  expect_true(abs(itemValues %*% solution$item_matrix[,1] - itemValues %*% solution$item_matrix[,2]) < 0.5)
  expect_true(abs(itemValues %*% solution$item_matrix[,1] - itemValues %*% solution$item_matrix[,3]) < 0.5)
  expect_true(abs(itemValues %*% solution$item_matrix[,2] - itemValues %*% solution$item_matrix[,3]) < 0.5)
})


test_that("cappedMaximinObjective works", {
  objective <- cappedMaximinObjective(nForms, itemValues, itemIDs = 1:nItems)

  allConstraints <- combineConstraints(testLength, objective, noOverlap,  catConstraints)
  solution <- useSolver(allConstraints, solver = "GL", verbose = FALSE)
  expect_equal(unname(rowSums(solution$item_matrix)),
               rep(c(0, 1), c(nItems - nForms * itemsPerForm, nForms * itemsPerForm)))
  expect_true(abs(itemValues %*% solution$item_matrix[,1] - itemValues %*% solution$item_matrix[,2]) < 0.5)
  expect_true(abs(itemValues %*% solution$item_matrix[,1] - itemValues %*% solution$item_matrix[,3]) < 0.5)
  expect_true(abs(itemValues %*% solution$item_matrix[,2] - itemValues %*% solution$item_matrix[,3]) < 0.5)
})


test_that("objective constraints return errors or warnings", {
  expect_error(minimaxObjective(nForms = c(2, 4), itemValues = 1:10, targetValue = 2,
                                itemIDs = 1:10),
               "'nForms' should be a vector of length 1.")
  expect_error(minimaxObjective(nForms = c(2, 4), itemValues = 1:10, targetValue = 2,
                                itemIDs = 1:4),
               "The length of 'itemIDs' and 'itemValues' should correspond.")


  items <- data.frame(numeric = 1:10, numeric_na = c(NA, 1:9), character = letters[1:10])

  expect_error(minimaxObjective(nForms = 2, itemValues = items, targetValue = 2,
                                itemIDs = 1:10),
               "'itemValues' has rows and columns, it should be a vector.")
  expect_warning(minimaxObjective(nForms = 2, itemValues = items[1], targetValue = 2,
                                  itemIDs = 1:10),
                 "'itemValues' has rows and columns, only the values in the first column are used.")
  expect_warning(minimaxObjective(nForms = 2, itemValues = items[,1, drop = FALSE],
                                  targetValue = 2, itemIDs = 1:10),
                 "'itemValues' has rows and columns, only the values in the first column are used.")

  # items2 <- tibble::as_tibble(items)
  # expect_error(minimaxObjective(nForms = 2, itemValues = items2, targetValue = 2,
  #                               itemIDs = 1:10),
  #              "'itemValues' has rows and columns, it should be a vector.")




  expect_error(minimaxObjective(nForms = 2, itemValues = 1:10, targetValue = NA,
                                itemIDs = 1:10),
               "'targetValue' should be a numeric vector.")

  expect_error(minimaxObjective(nForms = 2, itemValues = items[,3], targetValue = 2,
                                  itemIDs = 1:10),
                 "'itemValues' should be a numeric vector.")
  expect_error(minimaxObjective(nForms = 2, itemValues = items[,2], targetValue = 2,
                                  itemIDs = 1:10),
                 "'itemValues' should not contain NA values.")
  expect_error(minimaxObjective(nForms = 2, itemValues = items[,1], targetValue = as.numeric(NA),
                                itemIDs = 1:10),
               "'targetValue' should not contain NA values.")
})


