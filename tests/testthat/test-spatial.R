test_that("spatial works", {
  data(survey, package = "MASS")
  set.seed(21892)
  index <- design(survey[, c("Sex", "Smoke", "Age")], size_subset = 50,
                  iterations = 25)
  index2 <- spatial(index, survey[, c("Sex", "Smoke", "Age")],
                    rows = LETTERS[1:9],
                    columns = 1:12, iterations = 25)
  expect_length(index2, 50)
  expect_equivalent(table(lengths(index2)), as.table(c("4" = 13, "5" = 37)))
  expect_equal(names(index2), position_name(rows = LETTERS[1:5], 1:10)$name)
})

test_that("spatial works with replicates", {
  data(survey, package = "MASS")
  set.seed(4568)
  index <- replicates(survey[, c("Sex", "Smoke", "Age")], size_subset = 50,
                      iterations = 25, controls = 15)
  index2 <- spatial(index, survey[, c("Sex", "Smoke", "Age")], iterations = 25)
  expect_length(index2, 50)
  expect_false(any(is.na(unlist(index2))))
  expect_equivalent(table(lengths(index2)), as.table(c("6" = 23, "7" = 27)))
  expect_equal(names(index2), position_name(rows = LETTERS[1:5], 1:10)$name)
  expect_equal(max(unlist(index2)), nrow(survey))
})
