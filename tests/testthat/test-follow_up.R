test_that("follow_up works", {
  data(survey, package = "MASS")
  survey$batch[1:118] <- "old"

})
test_that("follow_up2 works", {
  data(survey, package = "MASS")
  old_n <- 118
  bn <- batch_names(create_subset(old_n, 20))
  survey$batch <- c(bn, rep(NA, nrow(survey) - old_n))
  follow_up2(survey)
  survey$batch <- c(rep("old", old_n), rep(NA, nrow(survey) - old_n))
  follow_up2(survey)
  survey$batch <- ifelse(survey$Clap == "Right", "old", "new")
  expect_error(follow_up2(survey))
})
