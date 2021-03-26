

test_that("item exclusion constraint", {
  tupl <- data.frame(i1 = c("I1", "I2"), i2 = c("I2", "I3"))
  out <- itemExclusionConstraint(nForms = 2, itemTuples = tupl, itemIDs = paste0("I", 1:3))
  expect_equal(out$A_binary[1, ], c(1, 1, 0, 0, 0, 0))
  expect_equal(out$A_binary[4, ], c(0, 0, 0, 0, 1, 1))

})

test_that("warning for exclusions on non existant items", {
  tupl <- data.frame(i1 = c("I1", "I2"), i2 = c("I2", "I4"))
  expect_warning(out <- itemExclusionConstraint(nForms = 2, itemTuples = tupl, itemIDs = paste0("I", 1:3)),
                 "The following item identifiers in the input column are not item identifiers in the 'idCol' column (check for correct sepPattern!): 'I4'", fixed = TRUE)
  expect_equal(dim(out$A_binary), c(2, 6))
  expect_equal(out$A_binary[1, ], c(1, 1, 0, 0, 0, 0))
  expect_equal(out$A_binary[2, ], c(0, 0, 0, 1, 1, 0))
})


test_that("item exclusion constraint big item pool", {
  items <- items_vera
  itemTuples <- itemTuples(items, idCol = "item", infoCol = "exclusions", sepPattern = ", ")

  out <- itemExclusionConstraint(nForms = 14, itemTuples = itemTuples, itemIDs = items$item)
  expect_true(inherits(out$A_binary, "Matrix"))
  expect_equal(dim(out$A_binary), c(630, 1120))

})


test_that("item exclusion constraint", {
  tupl <- data.frame(i1 = c("I1", "I2"), i2 = c("I2", "I3"), stringsAsFactors = FALSE)
  out <- itemInclusionConstraint(nForms = 2, itemTuples = tupl, itemIDs = paste0("I", 1:3))
  expect_equal(out$A_binary[1, ], c(1, -1, 0, 0, 0, 0))
  expect_equal(out$A_binary[4, ], c(0, 0, 0, 0, 1, -1))

})

test_that("with solver", {
  tupl <- data.frame(i1 = c("I1"), i2 = c("I2"), stringsAsFactors = FALSE)
  incl <- itemInclusionConstraint(nForms = 1, itemTuples = tupl, itemIDs = paste0("I", 1:3))
  len <- itemsPerFormConstraint(nForms = 1, targetValue = 2, itemIDs = paste0("I", 1:3))
  tif <- maxObjective(nForms = 1, itemValues = c(1, 1, 1.5), itemIDs = paste0("I", 1:3))
  txt <- capture_output(suppressMessages(out <- useSolver(list(incl, len, tif))))

  expect_equal(out$solution, c(1, 1, 0, 2))
  expect_equal(out$item_matrix$form_1, c(1, 1, 0))

})


test_that("warning for inclusions on non existant items", {
  tupl <- data.frame(i1 = c("I1", "I2"), i2 = c("I2", "I4"), stringsAsFactors = FALSE)
  expect_warning(out <- itemInclusionConstraint(nForms = 2, itemTuples = tupl, itemIDs = paste0("I", 1:3)),
                 "The following item identifiers in the input column are not item identifiers in the 'idCol' column (check for correct sepPattern!): 'I4'", fixed = TRUE)
  expect_equal(dim(out$A_binary), c(2, 6))
  expect_equal(out$A_binary[1, ], c(1, -1, 0, 0, 0, 0))
  expect_equal(out$A_binary[2, ], c(0, 0, 0, 1, -1, 0))
})


