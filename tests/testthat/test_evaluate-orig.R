context("evaluate_orig")

test_that("works", {
  set.seed(42)
  samples <- 10
  m <- matrix(rnorm(samples), nrow = samples)
  m[sample(seq_len(samples), size = 5), ] <- NA
  e <- evaluate_orig( m)
})
