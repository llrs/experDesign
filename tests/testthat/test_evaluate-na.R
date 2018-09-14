context("evaluate_na")

test_that("works", {
  set.seed(42)
  samples <- 10
  m <- matrix(rnorm(samples), nrow = samples)
  m[sample(seq_len(samples), size = 5), ] <- NA
  i <- create_subset(3, 4, samples)
  e <- evaluate_na(i, m)
  expect_equal(e, 0.375)
})
