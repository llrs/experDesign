pheno <- readRDS("samples2sequence.RDS")

library("minDiff")
o <- create_groups(pheno, sets_n = 4, criteria_nominal = c("SEX"),
                   repetitions = 1000)
