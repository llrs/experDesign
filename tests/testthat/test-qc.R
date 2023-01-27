test_that("qcSubset all", {
  index <- create_subset(100, 50, 2)
  QC_samples <- qcSubset(index, 10)
  expect_length(QC_samples, 10)
})

test_that("qcSubset by batch", {
  index <- create_subset(100, 50, 2)
  QC_samples <- qcSubset(index, 10, TRUE)
  expect_length(QC_samples, 2)
  expect_equal(lengths(QC_samples), c("SubSet1" = 10L, "SubSet2" = 10L))
})
