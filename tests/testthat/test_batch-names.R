context("batch_names")

test_that("works", {
  index <- create_subset(100, 50, 2)
  batch <- batch_names(index)
  expect_length(unique(batch), 2)
})
