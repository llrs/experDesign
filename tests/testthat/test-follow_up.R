test_that("follow_up works", {
  data(survey, package = "MASS")
  survey1 <- survey[1:118, ]
  survey2 <- survey[119:nrow(survey), ]
  expect_snapshot(fu <- follow_up(survey1, survey2, size_subset = 50,
                                  iterations = 10))
  expect_s3_class(fu, "data.frame")
})

test_that("follow_up2 works", {
  data(survey, package = "MASS")
  expect_error(follow_up2(survey, iterations = 10))

  old_n <- 118
  # old vs new
  survey$batch <- c(rep("old", old_n), rep(NA, nrow(survey) - old_n))
  expect_warning(
    expect_warning(
      expect_warning(
        expect_warning(
          fu1 <- follow_up2(survey, iterations = 10),
          "with the data."),
        "with the new samples"),
      "some problems with the new data."),
    "some problems with the old data.")
  expect_type(fu1, "character")
  # old vs new with confounding effects
  survey$batch <- ifelse(survey$Clap %in% "Right", "old", NA)
  expect_snapshot(follow_up2(survey, iterations = 10))

  # old with batches vs new
  bn <- batch_names(create_subset(old_n, 20))
  survey$batch <- c(bn, rep(NA, nrow(survey) - old_n))
  expect_snapshot(fu3 <- follow_up2(survey, iterations = 10))
  expect_type(fu3, "character")
  # old with batches and confounding effect vs new
  survey$batch <- ifelse(survey$Clap %in% "Right", "old", NA)
  bn <- batch_names(create_subset(sum(survey$Clap %in% "Right", na.rm = TRUE), 20))
  survey$batch[survey$batch %in% "old"] <- bn
  expect_snapshot(fu4 <- follow_up2(survey, iterations = 10))
  expect_type(fu4, "character")
})


test_that("valid_followup works", {
  data(survey, package = "MASS")
  survey1 <- survey[1:118, ]
  survey2 <- survey[119:nrow(survey), ]

  expect_snapshot(out <- valid_followup(survey1, survey2))
  expect_false(out)
  survey$batch <- NA
  survey$batch[1:118]  <- "old"

  expect_snapshot(out <- valid_followup(all_data = survey))
  expect_false(out)
})
