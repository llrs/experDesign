context("entropy")

test_that("Extremes", {
  e <- entropy(c("H", "T", "H", "T"))
  expect_equal(e, 1)
})
