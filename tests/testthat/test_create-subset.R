context("create_subset")

test_that("works",{
  i <- create_subset(100, 50, 2)
  expect_length(i, 2)
  expect_equal(sum(lengths(i)), 100)
})
test_that("works well",{
  i <- create_subset(size.data = 100, n = 4)
  expect_length(i, 4L)
})

test_that("use_index", {
  plates <- c("P1", "P2", "P1", "P2", "P2", "P3", "P1", "P3", "P1", "P1")
  out <- use_index(plates)
  expect_length(out, 3L)
  expect_equal(lengths(out), c("P1" = 5, "P2" = 3, "P3" = 2))
})
