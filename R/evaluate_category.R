
.evaluate_cat <- function(i, pheno, remove_e) {
  # Calculate the entropy for the subsets
  out_e <- sapply(i, function(x){
    vapply(droplevels(pheno[x, ]), entropy, numeric(1L))
  })
  out_e <- t(out_e)

  # Compare with the optimum 1 == random; 0 == all the same
  res_e <- 1-colMeans(out_e[, !remove_e], na.rm = TRUE)
  # Value to optimize
  opt_e <- sum(res_e, na.rm = TRUE)
  opt_e
}

#' Evaluate category
#'
#' @param i list of numeric indices of the data.frame
#' @param pheno Data.frame
#' @return Value to minimize
#' @export
evaluate_cat <- function(i, pheno) {
  num <- vapply(pheno, is.numeric, logical(1L))
  # Calculate the entropy for the categorical values
  original_e <- vapply(droplevels(pheno[, !num]), entropy, numeric(1L))
  # Remove those that are different in each sample (Hopefully just the name of the sample)
  remove_e <- original_e == 1
  .evaluate_cat(i, pheno[, !num], remove_e)
}
