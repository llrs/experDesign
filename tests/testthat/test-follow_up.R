test_that("follow_up works", {
  data(survey, package = "MASS")
  survey1 <- survey[1:118, ]
  survey2 <- survey[119:nrow(survey), ]
  fu <- follow_up(surve1, survey2)
})

test_that("follow_up2 works", {
  data(survey, package = "MASS")
  old_n <- 118
  # old vs new
  survey$batch <- c(rep("old", old_n), rep(NA, nrow(survey) - old_n))
  follow_up2(survey)

  # old vs new with counfounding effects
  survey$batch <- ifelse(survey$Clap %in% "Right", "old", NA)
  expect_error(follow_up2(survey))

  # old with batches vs new
  bn <- batch_names(create_subset(old_n, 20))
  survey$batch <- c(bn, rep(NA, nrow(survey) - old_n))
  follow_up2(survey)

  # old with batches and confounding effect vs new
  survey$batch <- ifelse(survey$Clap %in% "Right", "old", NA)
  bn <- batch_names(create_subset(sum(survey$Clap %in% "Right", na.rm = TRUE), 20))
  survey$batch[survey$batch == "old"] <- bn
  expect_error(follow_up2(survey))

})
