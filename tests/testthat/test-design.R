test_that("design works", {
  set.seed(44)
  samples <- data.frame(L = letters[1:25], Age = rnorm(25))
  index <- design(samples, 5, iterations = 10)
  expect_length(index, 5L)
  expect_equal(lengths(index), c("SubSet1" = 5L,
                                 "SubSet2" = 5L,
                                 "SubSet3" = 5L,
                                 "SubSet4" = 5L,
                                 "SubSet5" = 5L))
})
