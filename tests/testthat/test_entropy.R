context("entropy")

test_that("Extremes", {
  e <- entropy(c("H", "T", "H", "T"))
  expect_equal(e, 1)
  expect_equal(entropy(c("H", "H")), 0)
})

test_that("Ignores NA", {
  e1 <- entropy(c("H", "T", "H", "T", "H", "H", NA))
  e2 <- entropy(c("H", "T", "H", "T", "H", "H"))
  expect_equal(e1, e2)
})
