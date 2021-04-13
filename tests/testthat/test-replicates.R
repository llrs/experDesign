context("replicates")

test_that("works", {
  set.seed(45)
  samples <- data.frame(L = letters[1:25], Age = rnorm(25))
  index <- replicates(samples, 5, controls = 2, iterations = 10)
  expect_length(index, 9L)
})
