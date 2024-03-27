test_that("inspect works", {
  data(survey, package = "MASS")
  columns <- c("Sex", "Age", "Smoke")
  nas <- c(137, 70)
  index <- design(pheno = survey[-nas, columns], size_subset = 70,
                  iterations = 10)
  batches <- inspect(index, survey[-nas, columns])
  expect_true("batch" %in% colnames(batches))


  batches <- inspect(index, survey[-nas, ], omit = colnames(survey)[!colnames(survey) %in% columns])
  expect_true("batch" %in% colnames(batches))
})

test_that("inspect works with replicates", {
  data(survey, package = "MASS")
  nas <- c(137, 70)
  columns <- c("Sex", "Age", "Smoke")
  index <- replicates(pheno = survey[-nas, columns], size_subset = 70, controls = 5,
                  iterations = 10)
  survey$sample <- seq_len(nrow(survey))
  batches <- inspect(index, survey[-nas, ])
  t_samples <- table(batches$sample)
  expect_equal(table(t_samples), structure(c(`1` = 230L, `4` = 5L), .Dim = 2L, .Dimnames = list(
    t_samples = c("1", "4")), class = "table"))

  # TODO check order is right for the samples
  k <- batches$sample %in% names(t_samples[t_samples == 4])
  expect_true(all(table(batches$batch[k], batches$sample[k]) <= 1))
})

test_that("inspect with translate_index", {
  data(survey, package = "MASS")
  nas <- c(137, 70)
  columns <- c("Sex", "Age", "Smoke")
  index1 <- replicates(survey[-nas, columns], size_subset = 50,
                      iterations = 25, controls = 15)
  index2 <- spatial(index1, survey[-nas, columns], iterations = 25)
  i1 <- inspect(index1, survey[-nas, columns])
  i2 <- inspect(index2, i1, index_name = "spatial")
  expect_true(all(table(i2$batch, i2$spatial)<= 1))
})

  test_that("Warning on duplidate names", {
  data(survey, package = "MASS")
  columns <- c("Sex", "Age", "Smoke")
  expect_warning(index <- design(pheno = survey[, columns], size_subset = 70,
                  iterations = 10))
  batches <- inspect(index, survey[, columns])

  expect_warning(index2 <- design(pheno = batches, size_subset = 70,
                   iterations = 10))
  expect_warning(inspect(index2, batches))
  expect_no_warning(inspect(index2, batches, index_name = "batch2"))
})