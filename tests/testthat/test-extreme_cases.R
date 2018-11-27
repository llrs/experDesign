context("test-extreme_cases")

test_that("extreme_cases works", {
  set.seed(456)
  surv <- MASS::survey
  size <- optimum_size(surv)
  expect_message(
    expect_warning(samples <- extreme_cases(surv, size = size),
                 "Maximum number of iterations reached"),
    "Maximum value reached:")
  expect_length(samples, 1L)
})
