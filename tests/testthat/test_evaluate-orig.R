context("evaluate_orig")

test_that("works", {
  set.seed(42)
  samples <- 10
  m <- matrix(rnorm(samples), nrow = samples)
  m[sample(seq_len(samples), size = 5), ] <- NA
  expect_error(e <- evaluate_orig(m), "is not TRUE")

  colnames(m) <- "Age"
  e <- evaluate_orig( m)
  expect_equal(e["na", "Age"], 5L)
  expect_equal(e["entropy", "Age"], 0)
  expect_equal(e["mean", "Age"], mean(m[, 1], na.rm = TRUE))
  expect_equal(e["sd", "Age"], sd(m[, 1], na.rm = TRUE))
  expect_equal(e["mad", "Age"], mad(m[, 1], na.rm = TRUE))
})
