test_that("maxConstraint works", {
  nItems <- 20
  nForms <- 1
  itemValues <- c(rep(0, nItems)[-c(1:2)], rep(10, 2))

  testLength <- itemsPerFormConstraint(nForms, nItems, targetValue = 2)
  objective <- maxConstraint(nForms, nItems, itemValues)
  allConstraints <- c(testLength, objective)
  solution <- useSolver(allConstraints, solver = "GL", verbose = FALSE)
  expect_equal(solution$item_matrix$form_1[19:20], c(1, 1))
  expect_equal(solution$solution[nItems + 1], sum(itemValues))
})



test_that("minConstraint works", {
  nItems <- 20
  nForms <- 1
  itemValues <- seq_len(nItems)

  testLength <- itemsPerFormConstraint(nForms, nItems, operator = ">=", targetValue = 3)
  objective <- minConstraint(nForms, nItems, itemValues)
  allConstraints <- c(testLength, objective)
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

testLength <- itemsPerFormConstraint(nForms, nItems, operator = "=", targetValue = itemsPerForm)
noOverlap <- itemUsageConstraint(nForms, nItems)
target <- computeTargetValues(itemCategory, nForms, testLength = itemsPerForm)
catConstraints <- itemCategoryRange(nForms, nItems, itemCategory, target)


test_that("maximinConstraint works", {
  objective <- maximinConstraint(nForms, nItems, itemValues, allowedDeviation = 0.05)
  allConstraints <- c(testLength, objective, noOverlap)
  solution <- useSolver(allConstraints, solver = "GL", verbose = FALSE)
  expect_equal(unname(rowSums(solution$item_matrix)),
               rep(c(0, 1), c(nItems - nForms * itemsPerForm, nForms * itemsPerForm)))
  expect_true(abs(itemValues %*% solution$item_matrix[,1] - itemValues %*% solution$item_matrix[,2]) < 0.5)
  expect_true(abs(itemValues %*% solution$item_matrix[,1] - itemValues %*% solution$item_matrix[,3]) < 0.5)
  expect_true(abs(itemValues %*% solution$item_matrix[,2] - itemValues %*% solution$item_matrix[,3]) < 0.5)
})


test_that("cappedMaximinConstraint works", {
  objective <- cappedMaximinConstraint(nForms, nItems, itemValues)

  allConstraints <- c(testLength, objective, noOverlap,  catConstraints)
  solution <- useSolver(allConstraints, solver = "GL", verbose = FALSE)
  expect_equal(unname(rowSums(solution$item_matrix)),
               rep(c(0, 1), c(nItems - nForms * itemsPerForm, nForms * itemsPerForm)))
  expect_true(abs(itemValues %*% solution$item_matrix[,1] - itemValues %*% solution$item_matrix[,2]) < 0.5)
  expect_true(abs(itemValues %*% solution$item_matrix[,1] - itemValues %*% solution$item_matrix[,3]) < 0.5)
  expect_true(abs(itemValues %*% solution$item_matrix[,2] - itemValues %*% solution$item_matrix[,3]) < 0.5)
})





