test_that("optimum works", {
  size_data <- 50
  batches <- optimum_batches(size_data, 24)
  expect_equal(batches, 3)
  size <- optimum_subset(size_data, batches)
  expect_equal(size, 17)
})
