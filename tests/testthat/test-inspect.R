test_that("inspect works", {
  data(survey, package = "MASS")
  columns <- c("Sex", "Age", "Smoke")
  index <- design(pheno = survey[, columns], size_subset = 70,
                  iterations = 10)
  batches <- inspect(index, survey[, columns])
  expect_true("batch" %in% colnames(batches))


  batches <- inspect(index, survey, omit = colnames(survey)[!colnames(survey) %in% columns])
  expect_true("batch" %in% colnames(batches))
})
