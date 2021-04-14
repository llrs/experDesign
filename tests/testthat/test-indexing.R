
test_that("sizes_batches works", {
  out <- sizes_batches(size_data = 237, size_subset = 60, batches = 4)
  expect_equal(out, c(60, 59, 59, 59))

  expect_error(sizes_batches(size_data = 237, size_subset = 59, batches = 4),
               "batches or size_subset is too small to fit all the samples.")
})
