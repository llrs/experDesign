test_that("consitent_index works", {
  data(survey, package = "MASS")
  index <- expect_warning(design(survey[, c("Sex", "Smoke", "Age")], size_subset = 50,
                  iterations = 10))
  # Test error on index larger than data:
  # FIXME: what with replicates?
  expect_error(consistent_index(index, survey[1:40, columns]))
  # Test error on index shorter than data
  expect_error(consistent_index(index[1:2], survey[, columns]))
  index[[1]][1] <- 238
  # Test error on index with indices not in data
  expect_error(consistent_index(index, survey[, columns]))
})
