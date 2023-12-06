test_that("replicates works", {
  set.seed(45)
  samples <- data.frame(L = letters[1:25], Age = rnorm(25),
                        type = sample(LETTERS[1:5], 25, TRUE))
  index <- replicates(samples, 5, omit = "L", controls = 2, iterations = 10)
  expect_length(index, 9L)

  i <- lengths(index)
  expect_error(replicates(samples, i, omit = "L", controls = 2, iterations = 10))
})

test_that("Setting 0 replicates is an error", {
  data(survey, package = "MASS")
  set.seed(4568)
  nas <- c(137, 70)
  expect_error(replicates(survey[-nas, c("Sex", "Smoke", "Age")], size_subset = 50,
                      iterations = 25, controls = 0))
})
