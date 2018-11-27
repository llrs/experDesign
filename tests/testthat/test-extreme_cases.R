context("test-extreme_cases")

test_that("extreme_cases works", {
  surv <- MASS::survey
  size <- optimum_size(surv)
  samples <- extreme_cases(surv, size = size)
  expect_length(samples, 2L)
})
