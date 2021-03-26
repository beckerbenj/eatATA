#load("tests/testthat/helper_BlockExclusions.RData")
load("helper_BlockExclusions.RData")

test_that("check_solverOut checks correctly", {
  sol2 <- sol3 <- sol4 <- sol5 <- sol

  expect_error(check_solverOut(1), "'solverOut' must be a list.")
  expect_error(check_solverOut(sol[1:3]), "'solverOut' must be of length 4.")
  names(sol2)[1] <- "other"
  expect_error(check_solverOut(sol2), "'solverOut' must contain the elements 'solution_found', 'solution', 'solution_status' and 'item_matrix'.")
  sol3$solution_found <- as.character(sol3$solution_found)
  expect_error(check_solverOut(sol3), "'solverOut$solution_found' must be logical of length 1.", fixed = TRUE)
  sol4$solution_status <- TRUE
  expect_error(check_solverOut(sol4), "'solverOut$solution_status' must be character or numeric of length 1.", fixed = TRUE)
  sol5$item_matrix <- TRUE
  expect_error(check_solverOut(sol5), "'solverOut$item_matrix' must be data.frame.", fixed = TRUE)
})

test_that("check_solverOut is silent correctly", {
  expect_silent(check_solverOut(sol))
})

test_that("check_solution_true", {
  expect_silent(check_solution_true(sol))
  sol$solution_found <- FALSE
  expect_silent(check_solution_true(sol))

  items <- data.frame(ID = paste0("item_", 1:10),
                      itemValues = c(-4, -4, -2, -2, -1, -1, 20, 20, 0, 0),
                      itemIDs = paste0("it", 1:10),
                      stringsAsFactors = FALSE)

  usage <- itemUsageConstraint(nForms = 2, operator = "=", targetValue = 1, itemIDs = items$itemIDs)
  perForm <- itemsPerFormConstraint(nForms = 2, operator = "=", targetValue = 5, itemIDs = items$itemIDs)
  target <- minimaxObjective(nForms = 2, itemValues = items$itemValues,
                              targetValue = 0, itemIDs = items$itemIDs)
  inf_constr1 <- itemValuesConstraint(nForms = 2, itemValues = c(1, rep(0, nrow(items)-1)),
                                      operator = "=", targetValue = 1, itemIDs = items$itemIDs)
  suppressMessages(out <- useSolver(allConstraints = list(usage, perForm, target, inf_constr1),
                                  solver = "GLPK", verbose = FALSE))
  expect_error(check_solution_true(out))
})

