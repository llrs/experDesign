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
  expect_error(sizes_batches(size_data, size_batch, batches),
               "batches must be a single number bigger than 1.")
})

test_that("internal_batches", {
  size_data <- 50
  size_batch <- 16
  batches <- 1
  expect_length(internal_batches(size_data, size_batch, batches), batches)
  expect_true(internal_batches(size_data, size_batch, batches) <= size_batch)
  out <- internal_batches(237, 96, 3)
  expect_equal(out, c(79, 79, 79))
  out <- internal_batches(237, 79, 3)
  expect_equal(out, c(79, 79, 79))
  out <- internal_batches(237, 78, 3)
  expect_equal(out, c(78, 78, 78))
})
