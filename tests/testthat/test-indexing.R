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

test_that("translate_index works with duplicated output", {
  new_rows <- 1:60
  old_rows <- c(3L, 9L, 10L, 16L, 17L, 20L, 27L, 28L, 30L, 31L, 32L, 33L, 34L,
                35L, 40L, 41L, 42L, 44L, 45L, 48L, 49L, 4L, 5L, 7L, 8L, 9L, 10L,
                13L, 15L, 18L, 21L, 22L, 25L, 26L, 32L, 33L, 34L, 36L, 37L, 38L,
                39L, 47L, 1L, 2L, 6L, 9L, 10L, 11L, 12L, 14L, 19L, 23L, 24L,
                29L, 32L, 33L, 34L, 43L, 46L, 50L)
  i <- list(
    A1 = c(3L, 4L, 1L),
    B1 = c(9L, 39L, 34L),
    C1 = c(10L, 47L, 43L),
    D1 = c(16L, 5L, 2L),
    E1 = c(17L, 7L, 6L),
    F1 = c(20L, 8L, 9L),
    A2 = c(27L, 9L, 46L),
    B2 = c(28L, 10L, 50L),
    C2 = c(30L, 13L, 10L),
    D2 = c(31L, 15L, 11L),
    E2 = 32L,
    F2 = 33L,
    A3 = 34L,
    B3 = c(35L, 18L, 12L),
    C3 = c(40L, 21L, 14L),
    D3 = c(41L,22L, 19L),
    E3 = c(42L, 25L, 23L),
    F3 = c(44L, 26L, 24L),
    A4 = c(45L, 32L),
    B4 = c(48L, 33L),
    C4 = c(49L, 34L),
    D4 = c(36L, 29L),
    E4 = c(37L, 32L),
    F4 = c(38L, 33L)
  )
  ti <- translate_index(i, new_rows, old_rows)
  expect_true(all(sort(unlist(ti)) == new_rows))
  expect_false(any(table(unlist(ti)) > 1))

  index <- create_index(45, rep.int(9, 5), 5)
  old_rows <- seq_len(45)
  old_rows[2] <- 46
  new_rows <- seq_len(45)
  ti <- translate_index(index, old_rows, new_rows)
  expect_equal(length(unlist(index, FALSE, FALSE)),
               length(unlist(ti, FALSE, FALSE)))
})

test_that("translate_index works with normal index", {
  i <- create_index(45, rep.int(9, 5), 5)
  ti <- translate_index(i)
  expect_equal(i, ti)
})
