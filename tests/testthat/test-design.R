test_that("design works", {
  set.seed(44)
  samples <- data.frame(L = letters[1:25], Age = rnorm(25),
                        type = sample(LETTERS[1:5], 25, TRUE))
  index <- design(samples, omit = "L", 5, iterations = 10)
  expect_length(index, 5L)
  expect_equal(lengths(index), c("SubSet1" = 5L,
                                 "SubSet2" = 5L,
                                 "SubSet3" = 5L,
                                 "SubSet4" = 5L,
                                 "SubSet5" = 5L))
})


test_that("design works with previous batches", {
  set.seed(55)
  samples <- data.frame(L = letters[1:25], Age = rnorm(25),
                        type = sample(LETTERS[1:5], 25, TRUE))
  i0 <-  c("A" = 13, "B" = 12)
  expect_warning(i <- design(samples, size_subset = i0, iterations = 10),
                 "some problems")
  expect_equal(lengths(i), i0)
})
