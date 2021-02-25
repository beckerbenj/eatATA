


test_that("test if get_A_binary_forms works", {
  nItems <- 10
  nForms <- 3
  itemValues <- rep(1:2, 5)
  out <- get_A_binary_forms(nForms, nItems, itemValues, 2)

  expect_equal(dim(out), c(1, nItems * nForms))
  expect_equal(out[1, ], c(rep(0, nItems), itemValues, rep(0, nItems)))
  expect_is(out, "Matrix")

  out <- get_A_binary_forms(nForms, nItems, itemValues, 2)
})


test_that("test if get_A_binary_items works", {
  nItems <- 5
  nForms <- 3
  formValues <- c(1, 1, 0)
  out <- get_A_binary_items(nForms, nItems, formValues, whichItems = c(1, 4))

  expect_equal(dim(out), c(2, nItems * nForms))
  expect_equal(out[1, ], c(formValues[1], rep(0, nItems-1),
                           formValues[2], rep(0, nItems-1),
                           formValues[3], rep(0, nItems-1)))
  expect_equal(out[2, ], c(rep(0, 3),
                           formValues[1], rep(0, nItems-1),
                           formValues[2], rep(0, nItems-1),
                           formValues[3], 0))
  expect_is(out, "Matrix")
})


test_that("test if get_A_binary_items_forms works", {
  nItems <- 5
  nForms <- 3
  values <- rep(1:8)
  out <- get_A_binary_items_forms(nForms, nItems, values,
                                  whichForms = c(1, 3),
                                  whichItems = c(1, 3:5))

  expect_equal(dim(out), c(1, nItems * nForms))
  expect_equal(out[1, ], c(1, 0, 2, 3, 4,
                           0, 0, 0, 0, 0,
                           5, 0, 6, 7, 8))

  expect_is(out, "Matrix")
})



test_that("test if make_info works", {
  whichForms <- 2:5
  info_text <- "test"

  out <- make_info(info_text, whichForms = whichForms)

  expect_equal(dim(out), c(length(whichForms), 4))
  expect_equal(out$constraint, rep(info_text, length(whichForms)))
  expect_equal(out$rowNr, seq_along(whichForms))
  expect_equal(out$formNr, whichForms)
  expect_equal(out$itemNr, rep(NA, length(whichForms)))

  expect_is(out, "data.frame")


  whichItems <- 1:50
  info_text <- "test2"

  out <- make_info(info_text, whichItems = whichItems)

  expect_equal(dim(out), c(length(whichItems), 4))
  expect_equal(out$constraint, rep(info_text, length(whichItems)))
  expect_equal(out$rowNr, seq_along(whichItems))
  expect_equal(out$itemNr, whichItems)
  expect_equal(out$formNr, rep(NA, length(whichItems)))

  expect_is(out, "data.frame")

  whichForms <- c(1, 3)
  whichItems <- c(1, 3:5)
  info_text <- "test3"

  out <- make_info(info_text, whichForms = whichForms, whichItems = whichItems)

  expect_equal(dim(out), c(1, 4))
  expect_equal(out$constraint, info_text)
  expect_equal(out$rowNr, 1)
  expect_equal(out$itemNr, NA)
  expect_equal(out$formNr, NA)

  expect_is(out, "data.frame")

  expect_error(make_info(info_text),
               "'whichForms' and 'whichItems' should not be both NULL.")
})


test_that("newConstraint works", {
  nItems <- 10
  nForms <- 5
  itemValues <- rep(1:2, 5)
  whichForms <- c(2:4)

  out <- newConstraint(get_A_binary_forms(nForms, nItems, itemValues, whichForms),
                       A_real = NULL,
                       operators = rep("=", 3),
                       d = rep(0, 3),
                       nForms = nForms,
                       nItems = nItems,
                       sense = NULL,
                       info = make_info(whichForms, "test"))
  expect_equal(attr(out, "itemIDs"), sprintf(paste("it%0", nchar(nItems), "d", sep=''), seq_len(nItems)))
  expect_is(out, "constraint")

  out <- newConstraint(get_A_binary_forms(nForms, nItems, itemValues, whichForms),
                       A_real = NULL,
                       operators = rep("=", 3),
                       d = rep(0, 3),
                       nForms = nForms,
                       nItems = nItems,
                       sense = NULL,
                       info = make_info(whichForms, "test"),
                       itemIDs = paste("item", seq_len(nItems)))
  expect_equal(attr(out, "itemIDs"), paste("item", seq_len(nItems)))

  whichItems <- c(3, 6:8)
  values <- 1:12

  out <- newConstraint(get_A_binary_items_forms(nForms, nItems, values, whichForms, whichItems),
                       A_real = NULL,
                       operators = "=",
                       d = sum(1:12),
                       nForms = nForms,
                       nItems = nItems,
                       sense = NULL,
                       info = make_info("test", whichForms, whichItems),
                       itemIDs = paste("item", seq_len(nItems)))

  expect_equal(attr(out, "itemIDs"), paste("item", seq_len(nItems)))



  expect_error(newConstraint(
    get_A_binary_forms(nForms, nItems, itemValues, whichForms),
    A_real = NULL,
    operators = rep("=", 3),
    d = rep(0, 3),
    nForms = nForms,
    nItems = nItems,
    sense = NULL,
    info = make_info(whichForms, "test"),
    itemIDs = paste("it", 1:9)),
    "The number of 'itemIDs' does not correspond to 'nItems'")

  expect_error(newConstraint(
    get_A_binary_forms(nForms, nItems, itemValues, whichForms),
    A_real = matrix(c(0, 0 ,1), ncol = 1),
    operators = rep("=", 3),
    d = rep(0, 3),
    c_real = c(1, 0),
    nForms = nForms,
    nItems = nItems,
    sense = NULL,
    info = make_info(whichForms, "test")))

  expect_is(newConstraint(
    get_A_binary_forms(nForms, nItems, itemValues, whichForms),
    A_real = matrix(c(0, 0 ,1), ncol = 1),
    operators = rep("=", 3),
    d = rep(0, 3),
    nForms = nForms,
    nItems = nItems,
    sense = NULL,
    info = make_info(whichForms, "test")), "constraint")

  expect_error(newConstraint(
    get_A_binary_forms(nForms, nItems, itemValues, whichForms),
    A_real = NULL,
    operators = rep("=", 3),
    d = rep(0, 3),
    c_real = c(1, 0),
    nForms = nForms,
    nItems = nItems,
    sense = NULL,
    info = make_info(whichForms, "test")))

  expect_error(newConstraint(
    get_A_binary_forms(nForms, nItems, itemValues, whichForms),
    A_real = matrix(c(0, 0 ,1, 1, 1, 1), ncol = 1),
    operators = rep("=", 3),
    d = rep(0, 3),
    c_real = NULL,
    nForms = nForms,
    nItems = nItems,
    sense = NULL,
    info = make_info(whichForms, "test")))

  expect_error(newConstraint(
    get_A_binary_forms(nForms, nItems, itemValues, whichForms),
    A_real = matrix(c(0, 0 ,1, 1, 1, 1), ncol = 2),
    operators = rep("=", 3),
    d = rep(0, 3),
    c_real = NULL,
    nForms = nForms,
    nItems = nItems,
    sense = NULL,
    info = make_info(whichForms, "test")), "Check 'A_real' and 'c_real'")
})



test_that("makeFormConstraint works", {
  nItems <- 10
  nForms <- 5
  itemValues <- rep(1:2, 5)
  whichForms <- c(2:4)

  out <- makeFormConstraint(nForms, itemValues, realVar = NULL,
                            operator = "=", targetValue = 10,
                            whichForms, sense = NULL, info_text = NULL)
  expect_equal(out$A_binary, get_A_binary_forms(nForms, nItems, itemValues, whichForms))
  expect_equal(out$A_real, NULL)
  expect_equal(out$operator, rep("=", length(whichForms)))
  expect_equal(out$d, rep(10, length(whichForms)))
  expect_equal(out$c_binary, NULL)
  expect_equal(out$c_real, NULL)
  expect_equal(attr(out, "info"), make_info("itemValues", whichForms))
  expect_equal(attr(out, "sense"), NULL)
  expect_equal(attr(out, "itemIDs"), sprintf(paste("it%0", nchar(nItems), "d", sep=''), seq_len(nItems)))

  expect_is(out, "constraint")

  expect_error(makeFormConstraint(nForms, itemValues, realVar = NULL,
                                  operator = "=", targetValue = 10,
                                  whichForms = c(2, 6), sense = NULL, info_text = NULL),
               "'whichForms' should be a subset of all the possible test form numbers given 'nForms'.")
})




test_that("makeItemConstraint works", {
  nItems <- 5
  nForms <- 3
  formValues <- c(1, 1, 0)
  whichItems <- c(2:4)

  out <- makeItemConstraint(nForms, nItems, formValues, realVar = NULL,
                            operator = "=", targetValue = 1,
                            whichItems, sense = NULL, info_text = NULL)
  expect_equal(out$A_binary, get_A_binary_items(nForms, nItems, formValues, whichItems))
  expect_equal(out$A_real, NULL)
  expect_equal(out$operator, rep("=", length(whichItems)))
  expect_equal(out$d, rep(1, length(whichItems)))
  expect_equal(out$c_binary, NULL)
  expect_equal(out$c_real, NULL)
  expect_equal(attr(out, "info"), make_info("formValues", whichItems = whichItems))
  expect_equal(attr(out, "sense"), NULL)
  expect_equal(attr(out, "itemIDs"), sprintf(paste("it%0", nchar(nItems), "d", sep=''), seq_len(nItems)))

  out2 <- makeItemConstraint(nForms, nItems, formValues, realVar = NULL,
                            operator = "=", targetValue = 1,
                            whichItems = paste("it", whichItems), sense = NULL,
                            info_text = NULL,
                            itemIDs = paste("it", seq_len(nItems)))
  expect_equal(out$A_binary, out2$A_binary)
  expect_equal(out$A_real, out2$A_real)
  expect_equal(out$operator, out2$operator)
  expect_equal(out$d, out2$d)
  expect_equal(attr(out, "info"), attr(out2, "info"))
  expect_equal(attr(out, "sense"), attr(out2, "sense"))

  out3 <- makeItemConstraint(nForms, nItems, formValues, realVar = NULL,
                             operator = "=", targetValue = 1,
                             whichItems = whichItems, sense = NULL,
                             info_text = NULL,
                             itemIDs = paste("it", seq_len(nItems)))
  expect_equal(out2, out3)

  expect_is(out, "constraint")

  expect_error(makeItemConstraint(nForms, nItems, formValues, realVar = NULL,
                                  operator = "=", targetValue = 1,
                                  whichItems = c(1, 6), sense = NULL, info_text = NULL,
                                  itemIDs = paste0("item", seq_len(nItems))),
               "'whichItems' should be a subset of either all the possible items numbers given 'nItems', or of the 'itemIDs'.")
  expect_error(makeItemConstraint(nForms, nItems, formValues, realVar = NULL,
                                  operator = "=", targetValue = 1,
                                  whichItems = "it01", sense = NULL, info_text = NULL,
                                  itemIDs = paste0("item", seq_len(nItems))),
               "The itemIDs in 'whichItems' do not correspond with the 'itemIDs'.")

})



test_that("makeItemFormConstraint works", {
  nItems <- 5
  nForms <- 3
  values <- c(1, 1, 0)
  whichItems <- c(2:4)
  whichForms <- 2
  autoInfo <- paste0(
    paste0("formsNrs:", paste(whichForms, collapse = "-")),
    paste0(" + itemsNrs:", paste(whichItems, collapse = "-")),
    paste0(" = ", 1))

  out <- makeItemFormConstraint(nForms, nItems, values, realVar = NULL,
                            operator = "=", targetValue = 1, whichForms,
                            whichItems, sense = NULL, info_text = NULL)
  expect_equal(out$A_binary, get_A_binary_items_forms(nForms, nItems,
                                                      values, whichForms,whichItems))
  expect_equal(out$A_real, NULL)
  expect_equal(out$operator, "=")
  expect_equal(out$d, 1)
  expect_equal(out$c_binary, NULL)
  expect_equal(out$c_real, NULL)
  expect_equal(attr(out, "info"), make_info(autoInfo, whichForms, whichItems))
  expect_equal(attr(out, "sense"), NULL)
  expect_equal(attr(out, "itemIDs"), sprintf(paste("it%0", nchar(nItems), "d", sep=''), seq_len(nItems)))

  expect_is(out, "constraint")

  expect_error(makeItemFormConstraint(nForms, nItems, values, realVar = NULL,
                                  operator = "=", targetValue = 1,
                                  whichForms = 3, whichItems = c(1, 6), sense = NULL, info_text = NULL,
                                  itemIDs = paste0("item", seq_len(nItems))),
               "'whichItems' should be a subset of either all the possible items numbers given 'nItems', or of the 'itemIDs'.")
  expect_error(makeItemFormConstraint(nForms, nItems, values, realVar = NULL,
                                      operator = "=", targetValue = 1,
                                      whichForms = 4, whichItems = c(1, 2), sense = NULL, info_text = NULL,
                                      itemIDs = paste0("item", seq_len(nItems))),
               "'whichForms' should be a subset of all the possible test form numbers given 'nForms'.")
  expect_error(makeItemFormConstraint(nForms, nItems, formValues, realVar = NULL,
                                  operator = "=", targetValue = 1,
                                  whichForms = 2, whichItems = "it01", sense = NULL, info_text = NULL,
                                  itemIDs = paste0("item", seq_len(nItems))),
               "The itemIDs in 'whichItems' do not correspond with the 'itemIDs'.")

})


test_that("combine2Constraints works", {
  nItems <- 10
  nForms <- 5
  itemValues <- rep(1:2, 5)
  whichFormsX <- c(2:4)
  whichFormsY <- 5

  x <- makeFormConstraint(nForms, itemValues, realVar = NULL,
                            operator = "=", targetValue = 10,
                            whichFormsX, sense = NULL, info_text = NULL)
  y <- makeFormConstraint(nForms, itemValues, realVar = NULL,
                          operator = "<=", targetValue = 5,
                          whichFormsY, sense = NULL, info_text = NULL)
  out <- combine2Constraints(x, y)
  expect_equal(dim(out$A_binary), c(sum(length(c(whichFormsX, whichFormsY))), nItems * nForms))
  expect_equal(out$A_real, NULL)
  expect_equal(out$operator, c(rep("=", length(whichFormsX)), rep("<=", length(whichFormsY))))
  expect_equal(out$d, c(rep(10, length(whichFormsX)), rep(5, length(whichFormsY))))
  expect_equal(out$c_binary, NULL)
  expect_equal(out$c_real, NULL)
  expect_equal(attr(out, "info"), make_info("itemValues", c(whichFormsX, whichFormsY)))
  expect_equal(attr(out, "sense"), NULL)
  expect_equal(attr(out, "itemIDs"), sprintf(paste("it%0", nchar(nItems), "d", sep=''), seq_len(nItems)))
  expect_is(out, "constraint")

  z <- makeFormConstraint(nForms, itemValues, realVar = 1,
                          operator = "<=", targetValue = 5,
                          whichFormsX, sense = "min", info_text = "min")
  out2 <- combine2Constraints(out, z)
  expect_equal(dim(out2$A_binary), c(sum(length(c(whichFormsX, whichFormsY, whichFormsX))), nItems * nForms))
  expect_equal(out2$A_real, matrix(c(rep(0, 4), rep(1, 3)), ncol = 1))
  expect_equal(out2$operator, c(rep("=", length(whichFormsX)), rep("<=", length(c(whichFormsY, whichFormsX)))))
  expect_equal(out2$d, c(rep(10, length(whichFormsX)), rep(5, length(c(whichFormsY, whichFormsX)))))
  expect_equal(attr(out2, "info"), rbind(make_info("itemValues", c(whichFormsX, whichFormsY)),
                                         data.frame(rowNr = 5:7,
                                                    formNr = whichFormsX,
                                                    itemNr = NA,
                                                    constraint = "min")))
  expect_equal(attr(out2, "sense"), "min")
  expect_equal(out2$c_binary, NULL)
  expect_equal(out2$c_real, 1)
  expect_is(out2, "constraint")
})


test_that("combine2Constraints returns errors", {
  nItems <- 10
  nForms <- 5
  itemValues <- rep(1:2, 5)
  whichFormsX <- c(2:4)
  whichFormsY <- 5

  x <- makeFormConstraint(nForms, itemValues, realVar = NULL,
                          operator = "=", targetValue = 10,
                          whichFormsX, sense = NULL, info_text = NULL)

  expect_error(combine2Constraints(x, makeFormConstraint(nForms+1, itemValues, realVar = NULL,
                                                         operator = "<=", targetValue = 5,
                                                         whichFormsY, sense = NULL, info_text = NULL)),
               "The constraints cannot be combined, the number of forms differs.")
  expect_error(combine2Constraints(x, makeFormConstraint(nForms, itemValues[-1], realVar = NULL,
                                                         operator = "<=", targetValue = 5,
                                                         whichFormsY, sense = NULL, info_text = NULL)),
               "The constraints cannot be combined, the number of items in the pool differs.")
  expect_error(combine2Constraints(x, makeFormConstraint(nForms, itemValues, realVar = NULL,
                                                         operator = "<=", targetValue = 5,
                                                         whichFormsY, sense = NULL, info_text = NULL,
                                                         itemIDs = paste("it", seq_len(nItems)))),
               "The constraints cannot be combined, the itemIDs differ.")



  # add tests "The constraints cannot be combined: the 'sense' of the objective function differs."
})




test_that("combineConstraints works", {
  nItems <- 10
  nForms <- 5
  itemValues <- rep(1:2, 5)
  whichFormsX <- c(2:4)
  whichFormsY <- 5

  x <- makeFormConstraint(nForms, itemValues, realVar = NULL,
                          operator = "=", targetValue = 10,
                          whichFormsX, sense = NULL, info_text = NULL)
  y <- makeFormConstraint(nForms, itemValues, realVar = NULL,
                          operator = "<=", targetValue = 5,
                          whichFormsY, sense = NULL, info_text = NULL)
  z <- makeFormConstraint(nForms, itemValues, realVar = 1,
                          operator = "<=", targetValue = 5,
                          whichFormsX, sense = "min", info_text = "min")

  expect_equal(combineConstraints(x, y, z), combineConstraints(list(x, y, z)))

  out2 <- combineConstraints(x, y, z)

  expect_equal(dim(out2$A_binary), c(sum(length(c(whichFormsX, whichFormsY, whichFormsX))), nItems * nForms))
  expect_equal(out2$A_real, matrix(c(rep(0, 4), rep(1, 3)), ncol = 1))
  expect_equal(out2$operator, c(rep("=", length(whichFormsX)), rep("<=", length(c(whichFormsY, whichFormsX)))))
  expect_equal(out2$d, c(rep(10, length(whichFormsX)), rep(5, length(c(whichFormsY, whichFormsX)))))
  expect_equal(attr(out2, "info"), rbind(make_info("itemValues", c(whichFormsX, whichFormsY)),
                                         data.frame(rowNr = 5:7,
                                                    formNr = whichFormsX,
                                                    itemNr = NA,
                                                    constraint = "min")))
  expect_equal(attr(out2, "sense"), "min")
  expect_is(out2, "constraint")

  expect_error(combineConstraints(x, "a"), "All arguments should be of the 'constraint'-class.")
  expect_error(combineConstraints(x, list("a")), "All arguments should be of the 'constraint'-class.")
  expect_error(combineConstraints(y, x, list("a")), "All arguments should be of the 'constraint'-class.")
  expect_error(combineConstraints(list(2, x)), "All arguments should be of the 'constraint'-class.")

  expect_message(combineConstraints(list(x)), "The one constraint that was given is simply returned")
  expect_message(combineConstraints(x), "The one constraint that was given is simply returned")

})





