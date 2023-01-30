test_that("follow_up works", {
  data(survey, package = "MASS")
  survey1 <- survey[1:118, ]
  survey2 <- survey[119:nrow(survey), ]
    expect_warning(
      expect_warning(
        expect_warning(
          expect_warning(
            fu <- follow_up(survey1, survey2, size_subset = 50, iterations = 10)
        )
      )
    )
  )
  expect_s3_class(fu, "data.frame")
})

test_that("follow_up2 works", {
  data(survey, package = "MASS")
  old_n <- 118
  # old vs new
  survey$batch <- c(rep("old", old_n), rep(NA, nrow(survey) - old_n))
  expect_warning(
    expect_warning(
      expect_warning(
        fu1 <- follow_up2(survey),
        "with the data."),
      "with the new samples"),
    "some problems with the new data.")

  # old vs new with counfounding effects
  survey$batch <- ifelse(survey$Clap %in% "Right", "old", NA)
  expect_error(expect_warning(expect_warning(expect_warning(follow_up2(survey, iterations = 10)))))

  # old with batches vs new
  bn <- batch_names(create_subset(old_n, 20))
  survey$batch <- c(bn, rep(NA, nrow(survey) - old_n))
  expect_warning(expect_warning(expect_warning(fu3 <- follow_up2(survey, iterations = 10))))

  # old with batches and confounding effect vs new
  survey$batch <- ifelse(survey$Clap %in% "Right", "old", NA)
  bn <- batch_names(create_subset(sum(survey$Clap %in% "Right", na.rm = TRUE), 20))
  survey$batch[survey$batch %in% "old"] <- bn
  expect_warning(expect_warning(expect_warning(fu4 <- follow_up2(survey, iterations = 10))))

})
