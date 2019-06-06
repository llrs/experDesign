context("test-extreme_cases")

test_that("extreme_cases works", {
  set.seed(456)
  surv <- MASS::survey
  samples <- extreme_cases(surv, size = 119)
  expect_length(samples, 119L)
})

test_that("check_index works", {
  set.seed(456)
  surv <- MASS::survey
  index <- create_subset(size_data = nrow(surv), n = 2)
  out <- check_index(surv, index)
  expect_equal(dim(out), c(12L, 2L))

  i2 <- design(surv, size_subset = 119, iterations = 100)
  o2 <- check_index(surv, i2)
  expect_true(sum(out) >= sum(o2))
})
