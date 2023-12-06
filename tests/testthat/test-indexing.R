test_that("sizes_batches works", {
  out <- sizes_batches(size_data = 237, size_subset = 60, batches = 4)
  expect_equal(out, c(60, 59, 59, 59))

  expect_error(sizes_batches(size_data = 237, size_subset = 59, batches = 4),
               "batches or size_subset is too small to fit all the samples.")
})

test_that("create_index4index works", {
  i1 <- create_index(15, rep.int(5, 3), 3)
  i2 <- create_index4index(i1, size_subset = 3, n = 5, name = "spatial")
  bn1 <- batch_names(i1)
  bn2 <- batch_names(i2)
  expect_true(all(table(bn1, bn2) == 1))
})


test_that("translate_index works", {
  index <- create_index(45, rep.int(9, 5), 5)
  old_rows <- seq_len(47)[-c(2, 7)]
  new_rows <- seq_len(45)
  ti <- translate_index(index, old_rows, new_rows)
  expect_true(all(c(2, 7) %in% unlist(index, FALSE, FALSE)))
  expect_false(all(c(2, 7) %in% unlist(ti, FALSE, FALSE)))
})
