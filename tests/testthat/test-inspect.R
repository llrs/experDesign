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

test_that("inspect works with replicates", {
  data(survey, package = "MASS")
  columns <- c("Sex", "Age", "Smoke")
  index <- replicates(pheno = survey[, columns], size_subset = 70, controls = 5,
                  iterations = 10)
  survey$sample <- seq_len(nrow(survey))
  batches <- inspect(index, survey)
  t_samples <- table(batches$sample)
  expect_equal(table(t_samples), structure(c(`1` = 232L, `4` = 5L), .Dim = 2L, .Dimnames = list(
    t_samples = c("1", "4")), class = "table"))

  # TODO check order is right for the samples
  k <- batches$sample %in% names(t_samples[t_samples == 4])
  expect_true(all(table(batches$batch[k], batches$sample[k]) <= 1))
})
