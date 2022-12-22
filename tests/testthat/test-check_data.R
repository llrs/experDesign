test_that("check_data works", {

  data <- expand.grid(sex = c("M", "F"), class = c("lower", "median", "high"))
  expect_false(expect_warning(check_data(data),
                              "no replicates; i.e. just one sample"))

  expect_false(expect_warning(check_data(data[-c(1, 3), ]), "category with just one sample"))
  data2 <- rbind(data, data)
  expect_true(expect_warning(check_data(data2), NA))
})
