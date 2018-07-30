#' Evaluate category
#'
#' Looks if the nominal or character columns are equally distributed according
#' to the entropy and taking into account the independence between batches
#' @param i list of numeric indices of the data.frame
#' @param pheno Data.frame with information about the samples
#' @return Value to minimize
#' @seealso \code{\link{evaluate_number}}, \code{\link{evaluate_independence}}
#' @export
evaluate_category <- function(i, pheno) {
  num <- vapply(pheno, is.numeric, logical(1L))
  stopifnot(sum(!num) >= 1)
  # Calculate the entropy for the categorical values
  original_e <- vapply(droplevels(pheno[, !num]), entropy, numeric(1L))
  # Remove those that are different in each sample (Hopefully just the name of the sample)
  remove_e <- original_e == 1
  opt_e <- .evaluate_cat(i, pheno[, !num, drop = FALSE], remove_e)
  opt_i <- evaluate_independence(i, pheno[, !num, drop = FALSE])
  sum(opt_e, opt_i)
}

.evaluate_cat <- function(i, pheno, remove_e) {
  # Calculate the entropy for the subsets
  out_e <- sapply(i, function(x){
    vapply(droplevels(pheno[x, , drop = FALSE]), entropy, numeric(1L))
  })
  out_e <- t(out_e)

  # Compare with the optimum 1 == random; 0 == all the same
  res_e <- 1-colMeans(out_e[, !remove_e, drop = FALSE], na.rm = TRUE)
  # Value to optimize, each difference is important
  opt_e <- sum(abs(res_e), na.rm = TRUE)
  opt_e
}

#' Compare independence by chisq.test
#'
#' Looks the independence between the categories and the batches
#' @param i Index of subsets
#' @param pheno A data.frame with the information about the samples
#' @return Returns a vector with the p-values of the chisq.test between the
#' category and the subset
#' @seealso \code{\link{evaluate_category}}
#' @export
evaluate_independence <- function(i, pheno) {
  num <- vapply(pheno, is.numeric, logical(1L))

  stopifnot(sum(!num) >= 1)
  batches <- batch_names(i)
  .evaluate_ind(batches, pheno[, !num, drop = FALSE])
}

.evaluate_ind <- function(batch, pheno) {
  vapply(pheno, function(x) {
    suppressWarnings(chisq.test(table(batch, x))$p.value)
  }, numeric(1L))
}
