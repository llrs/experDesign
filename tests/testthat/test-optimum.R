test_that("optimum works", {
  size_data <- 50
  batches <- optimum_batches(size_data, 24)
  expect_equal(batches, 3)
  size <- optimum_subset(size_data, batches)
  expect_equal(size, 17)
})

test_that("sizes_batches", {
  size_data <- 50
  size_batch <- 16
  batches <- 4
  expect_equal(sum(sizes_batches(size_data, size_batch, batches)), size_data)
  expect_length(sizes_batches(size_data, size_batch, batches), batches)
  expect_true(all(sizes_batches(size_data, size_batch, batches) <= size_batch))
  batches <- 1
  expect_error(sizes_batches(size_data, size_batch, batches), "There should be more than one batch.")
})

test_that("internal_batches", {
  size_data <- 50
  size_batch <- 16
  batches <- 1
  expect_length(internal_batches(size_data, size_batch, batches), batches)
  expect_true(internal_batches(size_data, size_batch, batches) <= size_batch)
})