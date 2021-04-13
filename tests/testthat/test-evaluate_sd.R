context("evaluate_sd")

test_that("works", {
  set.seed(47)
  samples <- 10
  m <- matrix(rnorm(samples), nrow = samples)
  i <- create_subset(samples, 4, 3)
  e <- evaluate_sd(i, m)
  expect_length(e, 1L)
})
