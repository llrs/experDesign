context("simplify2matrix")
test_that("works",{
  l <- list("a" = 1, "b" = 1)
  m <- simplify2matrix(l)
  expect_true(is(m, "matrix"))
})
