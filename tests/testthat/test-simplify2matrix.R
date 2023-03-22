test_that("simplify2matrix works",{
  l <- list("a" = 1, "b" = 1)
  m <- simplify2matrix(l)
  expect_true(is(m, "matrix"))
})
