test_that("evaluate_na works", {
  set.seed(42)
  samples <- 10
  m <- matrix(rnorm(samples), nrow = samples)
  m[sample(seq_len(samples), size = 5), ] <- NA
  i <- create_subset(samples, 3, 4)
  e <- evaluate_na(i, m)
  expect_equal(e, 0.375)
})
