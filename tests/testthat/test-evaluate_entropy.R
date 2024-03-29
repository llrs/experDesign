test_that("evaluate_entropy works", {
  data(survey, package = "MASS")
  nas <- c(137, 70)
  index <- design(survey[-nas, c("Sex", "Smoke", "Age")], size_subset = 50,
                  iterations = 50)
  # Note that numeric columns will be omitted:
  out <- evaluate_entropy(index, survey[, c("Sex", "Smoke", "Age")])
  expect_length(out, 2L)
  expect_equal(names(out), c("Sex", "Smoke"))
})
