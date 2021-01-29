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
  expect_error(check_solution_true(sol),
               "'solverOut' does not contain a feasible solution.")
})

