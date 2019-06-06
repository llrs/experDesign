
test_that("sizes_batches works", {
  out <- sizes_batches(237, size_subset = 60, 4)
  expect_equal(out, c(60, 59, 59, 59))

  expect_equal(sizes_batches(237, size_subset = 59, 4), 59)
})
