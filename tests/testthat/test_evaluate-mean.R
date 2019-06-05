context("evaluate_mean")

test_that("works", {
  set.seed(46)
  samples <- 10
  m <- matrix(rnorm(samples), nrow = samples)
  i <- create_subset(samples, n = 3)
  e <- evaluate_mean(i, m)
  expect_length(e, 1L)
})
