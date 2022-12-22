test_that("replicates works", {
  set.seed(45)
  samples <- data.frame(L = letters[1:25], Age = rnorm(25),
                        type = sample(LETTERS[1:5], 25, TRUE))
  index <- replicates(samples, 5, omit = "L", controls = 2, iterations = 10)
  expect_length(index, 9L)
})
