test_that("extreme_cases works", {
  set.seed(456)
  surv <- MASS::survey
  samples <- extreme_cases(surv, size = 119, iterations = 10)
  expect_length(samples, 119L)
})

test_that("check_index works", {
  set.seed(456)
  surv <- MASS::survey
  nas <- c(137, 70)
  index <- create_subset(size_data = nrow(surv)-length(nas), n = 2)
  out <- check_index(surv[-nas, c("Sex", "Smoke", "Age")], index)
  expect_equal(dim(out), c(4L, 2L))

  i2 <- design(surv[-nas, c("Sex", "Smoke", "Age")],
               size_subset = 119, iterations = 100)
  o2 <- check_index(surv[-nas, c("Sex", "Smoke", "Age")], i2)
  expect_true(sum(out) >= sum(o2))
})
