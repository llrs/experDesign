test_that("spatial works", {
  data(survey, package = "MASS")
  index <- design(survey[, c("Sex", "Smoke", "Age")], size_subset = 50,
                  iterations = 25)
  index2 <- spatial(index, survey[, c("Sex", "Smoke", "Age")], iterations = 25)
  expect_length(index2, 50)
  expect_equivalent(table(lengths(index2)), as.table(c("4" = 13, "5" = 37)))
  expect_equal(names(index2), position_name(rows = LETTERS[1:5], 1:10)$name)
})
