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


test_that("design with previous batches", {
  set.seed(55)
  samples <- data.frame(L = letters[1:25], Age = rnorm(25),
                        type = sample(LETTERS[1:5], 25, TRUE))
  i0 <-  c("A" = 13, "B" = 12)
  expect_warning(i <- design(samples, size_subset = i0, iterations = 10),
                 "some problems")
  expect_equal(lengths(i), i0)

  # Unamed size_subsets but multiple names
  i1 <- i0
  names(i1) <- NULL
  expect_warning(i <- design(samples, size_subset = i1,
                             iterations = 10, name = names(i0)))
  expect_equal(lengths(i), i0)

  # Unamed size_subsets but multiple names
  i1 <- i0
  names(i1) <- NULL
  expect_error(expect_warning(design(samples, size_subset = i1,
                                     iterations = 10, name = LETTERS[1:3])))

})

test_that("design with blocked variables", {
  set.seed(365)
  df <- data.frame(A = sample(LETTERS[1:6], 2),
                    B = rnorm(6),
                    C = c(rep("a", 3), rep("b", 3)))
  expect_snapshot(i <- design(df, size_subset = 2, block = "C", iterations = 1))
  expect_no_error(i <- design(df, size_subset = 2, block = "C", iterations = 10))

})
