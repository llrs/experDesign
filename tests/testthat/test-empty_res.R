test_that("empty_res works", {
  d <- data.frame(a = letters)
  empty_res(d, is_num(d))
})
