test_that("spatial works", {
  data(survey, package = "MASS")
  set.seed(21892)
  nas <- c(137, 70)
  index <- design(survey[-nas, c("Sex", "Smoke", "Age")], size_subset = 50,
                  iterations = 25)
  index2 <- spatial(index, survey[-nas, c("Sex", "Smoke", "Age")],
                    rows = LETTERS[1:9],
                    columns = 1:12, iterations = 25)
  expect_length(index2, 9*12)
  expect_equal(table(lengths(index2)), as.table(c("2" = 89, "3" = 19)), ignore_attr = TRUE)
  expect_equal(names(index2), position_name(rows = LETTERS[1:9], 1:12)$name)
})

test_that("spatial works with replicates", {
  data(survey, package = "MASS")
  set.seed(4568)
  nas <- c(137, 70)
  index <- replicates(survey[-nas, c("Sex", "Smoke", "Age")], size_subset = 50,
                      iterations = 25, controls = 15)
  index2 <- spatial(index, survey[-nas, c("Sex", "Smoke", "Age")], iterations = 25)
  expect_length(index2, 50)
  expect_false(any(is.na(unlist(index2))))
  expect_equal(table(lengths(index2)), as.table(c("6" = 25, "7" = 25)), ignore_attr = TRUE)
  expect_equal(names(index2), position_name(rows = LETTERS[1:5], 1:10)$name)
  expect_equal(max(unlist(index2)), nrow(survey))
})
