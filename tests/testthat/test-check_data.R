test_that("check_data works", {

  data <- expand.grid(sex = c("M", "F"), class = c("lower", "median", "high"))
  expect_warning(out <- check_data(data), " i.e. just one sample.")
  expect_false(out)

  expect_warning(
    expect_warning(
      expect_warning(out <- check_data(data[-c(1, 3), ]),
                     "don't have all combinations"),
      " category with just one sample"),
    "no replicates; i.e. just one sample")
  expect_false(out)
  data2 <- rbind(data, data)
  expect_true(expect_warning(check_data(data2), NA))
})
