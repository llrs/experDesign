test_that("compare_index works", {
  index1 <- create_subset(50, 24)
  index2 <- batch_names(create_subset(50, 24))
  metadata <- expand.grid(height = seq(60, 80, 5), weight = seq(100, 300, 50),
                           sex = c("Male","Female"))
  ci <- compare_index(metadata, index1, index2)
  expect_equal(dim(ci), c(3, 3))

  metadata$index <- batch_names(index1)
  ci <- compare_index(metadata, "index", index2)
  expect_equal(dim(ci), c(3, 3))
})
