#' Evaluate entropy
#'
#' Looks if the nominal or character columns are equally distributed according
#' to the entropy and taking into account the independence between batches.
#' If any column is different in each row it is assumed to be the sample names
#' and thus omitted.
#' @param i list of numeric indices of the data.frame
#' @param pheno Data.frame with information about the samples
#' @return Value to minimize
#' @family functions to evaluate samples
#' @family functions to evaluate categories
#' @export
#' @examples
#' data(survey, package = "MASS")
#' index <- design(survey[, c("Sex", "Smoke", "Age")], size_subset = 50,
#'                 iterations = 50)
#' # Note that numeric columns will be omitted:
#' evaluate_entropy(index, survey[, c("Sex", "Smoke", "Age")])
evaluate_entropy <- function(i, pheno) {

  num <- is_num(pheno)
  stopifnot(sum(!num) >= 1)
  pheno_o <- droplevels(pheno[, !num, drop = FALSE])
  # Calculate the entropy for the categorical values
  original_e <- vapply(pheno_o, function(x){length(unique(x))/length(x)}, numeric(1L))
  # Remove those that are different in each sample (Hopefully just the name of the sample)
  remove_e <- original_e == 1
  .evaluate_cat(i, pheno_o, remove_e)
}

.evaluate_cat <- function(i, pheno, remove_e) {
  # Calculate the entropy for the subsets
  out_e <- lapply(i, function(x){
    vapply(pheno[x, , drop = FALSE], entropy, numeric(1L))
  })
  out_e <- t(simplify2matrix(out_e))

  # Compare with the optimum 1 == random; 0 == all the same
  out <- 1 - colMeans(out_e[, !remove_e, drop = FALSE], na.rm = TRUE)
  abs(out)
}

#' Compare independence by chisq.test
#'
#' Looks the independence between the categories and the batches.
#' @param i Index of subsets.
#' @param pheno A data.frame with the information about the samples.
#' @return Returns a vector with the p-values of the chisq.test between the
#' category and the subset.
#' @importFrom stats chisq.test
#' @family functions to evaluate samples
#' @family functions to evaluate categories
#' @export
#' @examples
#' data(survey, package = "MASS")
#' index <- design(survey[, c("Sex", "Smoke", "Age")], size_subset = 50,
#'                 iterations = 50)
#' # Note that numeric columns will be omitted:
#' evaluate_independence(index, survey[, c("Sex", "Smoke", "Age")])
evaluate_independence <- function(i, pheno) {
  num <- is_num(pheno)

  stopifnot(sum(!num) >= 1)
  batches <- batch_names(i)
  .evaluate_ind(batches, pheno[unlist(i), !num, drop = FALSE])
}

.evaluate_ind <- function(batch, pheno) {
  vapply(pheno, function(x) {
    suppressWarnings(stats::chisq.test(table(batch, x))$p.value)
  }, numeric(1L))
}
