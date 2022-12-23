test_that("works" ,{
  set.seed(43)
  samples <- data.frame(L = letters[1:25], Age = rnorm(25),
                        type = sample(LETTERS[1:5], 25, TRUE))
  i <- create_subset(25, 5, 5)
  arr <- evaluate_index(i, samples[, -1])
  expect_equal(arr["entropy", "Age",], c("SubSet1" = 0,
                                         "SubSet2" = 0,
                                         "SubSet3" = 0,
                                         "SubSet4" = 0,
                                         "SubSet5" = 0))
})
