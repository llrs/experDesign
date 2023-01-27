test_that("insert works", {
  m <- matrix(0, ncol = 2, nrow = 2,
              dimnames = list(LETTERS[1:2], letters[1:2]))
  vec <- c("a" = 1)
  i <- insert(m, vec, "A")
  expect_equal(i["A", "a"], 1L)
  m2 <- matrix(1, ncol = 2, nrow = 1,
               dimnames = list(LETTERS[1], letters[1:2]))
  i <- insert(m, m2, "A")
  expect_equal(i["A", "a"], 1L)
  expect_equal(i["A", "b"], 1L)
})
