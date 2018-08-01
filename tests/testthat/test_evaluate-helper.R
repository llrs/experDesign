context("evaluate_helper")

test_that("works", {
  m <- matrix(1, ncol = 2, nrow = 2)
  vec <- 1:2
  res <- evaluate_helper(m, vec)
  expect_equal(res, c(0L, 1L))
})

test_that("mean", {
  m <- matrix(1, ncol = 2, nrow = 2)
  m[1, 1] <- 0
  vec <- 1:2
  res <- evaluate_helper(m, vec)
  expect_equal(res, c(0.5, 1L))
})
