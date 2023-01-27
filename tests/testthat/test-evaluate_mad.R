test_that("evaluate_mad works", {
  set.seed(48)
  samples <- 10
  m <- matrix(rnorm(samples), nrow = samples)
  i <- create_subset(samples, 4, 3)
  e <- evaluate_mad(i, m)
  expect_length(e, 1L)
})
