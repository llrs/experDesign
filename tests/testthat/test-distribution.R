test_that("distribution works", {
  data(survey, package = "MASS")
  set.seed(4565)
  columns <- c("Sex", "Age", "Smoke")
  nas <- c(137, 70)
  index <- design(pheno = survey[-nas, columns], size_subset = 70,
                  iterations = 10)
  batches <- inspect(index, survey[, columns])
  expect_true(distribution(batches, "Sex"))
  expect_true(distribution(batches, "Smoke"))
})
