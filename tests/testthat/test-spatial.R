test_that("spatial works", {
  data(survey, package = "MASS")
  set.seed(21892)
  nas <- c(137, 70)
  index <- design(survey[-nas, c("Sex", "Smoke", "Age")], size_subset = 50,
                  iterations = 25)
  index2 <- spatial(index, survey[-nas, c("Sex", "Smoke", "Age")],
                    rows = LETTERS[1:9],
                    columns = 1:12, iterations = 25)
  expect_lte(length(index2), 9*12)
  expect_true(all(names(index2) %in% position_name(rows = LETTERS[1:9], 1:12)$name))
  expect_false(any(table(batch_names(index), batch_names(index2)) > 1))
})

test_that("spatial works with replicates", {
  data(survey, package = "MASS")
  set.seed(4568)
  nas <- c(137, 70)
  index <- replicates(survey[-nas, c("Sex", "Smoke", "Age")], size_subset = 50,
                      iterations = 25, controls = 15)
  index2 <- spatial(index, survey[-nas, c("Sex", "Smoke", "Age")], iterations = 25)
  expect_lte(length(index2), 50)
  expect_false(any(is.na(unlist(index2))))
  expect_true(all(names(index2) %in% position_name(rows = LETTERS[1:5], 1:10)$name))
  expect_true(all(sort(unlist(index2)) == seq_len(325)))
})

test_that("spatial don't duplicate samples", {
  data(survey, package = "MASS")
  set.seed(4568)
  nas <- c(137, 70)
  index <- create_subset(NROW(survey[-nas, ]), size_subset = 50)
  index2 <- spatial(index, survey[-nas, c("Sex", "Smoke", "Age")], iterations = 25)
  uniqueness <- vapply(index2, function(x){length(unique(x)) == length(x)},
                      FUN.VALUE = logical(1L))
  # Avoid placing the a sample twice in a position
  expect_false(any(!uniqueness))
  # Avoid placing a sample in the same well in the same subset
  expect_false(any(table(batch_names(index), batch_names(index2)) > 1))
})

test_that("Removing rows works", {
  data(survey, package = "MASS")
  set.seed(21829)
  nas <- c(137, 70)
  index <- design(survey[-nas, c("Sex", "Smoke", "Age")], size_subset = 50,
                  iterations = 25)
  index2 <- spatial(index, survey[-nas, c("Sex", "Smoke", "Age")],
                    rows = LETTERS[1:9], remove_positions = "B",
                    columns = 1:12, iterations = 25)
  expect_lte(length(index2), 9*12)
  expect_true(all(names(index2) %in% position_name(rows = LETTERS[1:9], 1:12)$name))
  expect_false(any(table(batch_names(index), batch_names(index2)) > 1))
})

test_that("Removing columns works", {
  data(survey, package = "MASS")
  set.seed(21289)
  nas <- c(137, 70)
  index <- design(survey[-nas, c("Sex", "Smoke", "Age")], size_subset = 50,
                  iterations = 25)
  index2 <- spatial(index, survey[-nas, c("Sex", "Smoke", "Age")],
                    rows = LETTERS[1:9], remove_positions =  "A",
                    columns = 1:12, iterations = 25)
  expect_lte(length(index2), 9*12)
  expect_true(all(names(index2) %in% position_name(rows = LETTERS[1:9], 1:12)$name))
  expect_false(any(table(batch_names(index), batch_names(index2)) > 1))
})