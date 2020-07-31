

tdat <- data.frame(ID = 1:3, d1=c(1, 0, 0), d2 = c(0, 1, 0), d3 = c(0, 0, 1))
tdat_m <- data.frame(ID = 1:3, d1=c(1, NA, NA), d2 = c(NA, 1, NA), d3 = c(NA, NA, 1))

# faulty examples
tdat2 <- data.frame(ID = 1:3, d1=c(2, 0, 0), d2 = c(0, 1, 0), d3 = c(0, 0, 1))
tdat3 <- data.frame(ID = 1:3, d1=c(1, 1, 0), d2 = c(0, 1, 0), d3 = c(0, 0, 1))

tdat_w <- data.frame(ID = 1:3, d1=c(1, 0, 0), d2 = c(0, 1, 0), d3 = c(0, 0, 0))

test_that("Errors dummiesToFactor", {
  expect_error(dummiesToFactor(1, dummies = "a", facVar = "b"), "'dat' needs to be a data.frame.")
  expect_error(dummiesToFactor(tdat, dummies = 1, facVar = "b"), "'dummies' needs to be a character vector.")
  expect_error(dummiesToFactor(tdat, dummies = "d1", facVar = 1), "'facVar' needs to be a character vector of length 1.")
  expect_error(dummiesToFactor(tdat, dummies = "d1", facVar = "newFact", nameEmptyCategory = 1), "'nameEmptyCategory' needs to be a character vector of length 1.")
  expect_error(dummiesToFactor(tdat, dummies = "d1", facVar = "newFact", nameEmptyCategory = c("a", "b")), "'nameEmptyCategory' needs to be a character vector of length 1.")
  expect_error(dummiesToFactor(tdat, dummies = "d1", facVar = c("b", "h")),
               "'facVar' needs to be a character vector of length 1.")
  expect_error(dummiesToFactor(tdat, dummies = "d1", facVar = "ID"), "'facVar' is an existing column in 'dat'.")
  expect_error(dummiesToFactor(tdat2, dummies = c("d1", "d2", "d3"), facVar = "newFact"),
               "All values in the 'dummies' columns have to be 0, 1 or NA.")
  expect_error(dummiesToFactor(tdat3, dummies = c("d1", "d2", "d3"), facVar = "newFact"),
               "For these rows, more than 1 dummy variable is 1: 2")
})


test_that("dummiesToFactor", {
  out <- dummiesToFactor(tdat, c("d1", "d2", "d3"), "newFac")
  expect_equal(names(out)[5], "newFac")
  expect_equal(out$newFac, factor(c("d1", "d2", "d3")))

  out2 <- dummiesToFactor(tdat_m, c("d1", "d2", "d3"), "newFac")
  expect_equal(names(out2)[5], "newFac")
  expect_equal(out2$newFac, factor(c("d1", "d2", "d3")))
})


test_that("dummiesToFactor", {
  w <- capture_warnings(out <- dummiesToFactor(tdat_w, c("d1", "d2", "d3"), "newFac"))
  expect_equal(names(out)[5], "newFac")
  expect_equal(out$newFac, factor(c("d1", "d2", "_none_")))

  expect_equal(w, "For these rows, there is no dummy variable equal to 1: 3\nA '_none_ 'category is created for these rows.")
})
