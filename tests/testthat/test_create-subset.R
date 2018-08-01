context("create_subset")

test_that("works",{
  i <- create_subset(50, 2, 100)
  expect_length(i, 2)
  expect_equal(sum(lengths(i)), 100)
})
