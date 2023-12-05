test_that("batch_names works", {
  index <- create_subset(100, 50, 2)
  batch <- batch_names(index)
  expect_length(unique(batch), 2)
  expect_true(all(batch[index[[1]]] == names(index)[1]))
  expect_true(all(batch[index[[2]]] == names(index)[2]))


  plates <- c("P1", "P2", "P1", "P2", "P2", "P3", "P1", "P3", "P1", "P1")
  expect_equal(batch_names(use_index(plates)), plates)
})
