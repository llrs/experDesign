test_that("distribution works", {
  data(survey, package = "MASS")
  set.seed(4565)
  columns <- c("Sex", "Age", "Smoke")
  index <- design(pheno = survey[, columns], size_subset = 70,
                  iterations = 10)
  batches <- inspect(index, survey[, columns])
  expect_true(distribution(batches, "Sex"))
  expect_true(distribution(batches, "Smoke"))
})
