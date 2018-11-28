context("test-extreme_cases")

test_that("extreme_cases works", {
  set.seed(456)
  surv <- MASS::survey
  size <- optimum_size(surv)
  expect_message(
    expect_warning(samples <- extreme_cases(surv, size = size),
                 "Maximum number of iterations reached"),
    "Maximum value reached:")
  expect_length(samples, 119L)
})

test_that("check_index works", {
  set.seed(456)
  surv <- MASS::survey
  index <- create_subset(size.data = nrow(surv), n = 2)
  out <- check_index(surv, index)
  expect_equal(dim(out), c(12L, 2L))
})
