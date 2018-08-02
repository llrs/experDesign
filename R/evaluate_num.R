#' Evaluates the mean of the numeric values
#'
#' Looks for the standard deviation of the numeric values
#' @param i List of indices
#' @param pheno Data.frame with the samples
#' @return A matrix with the standard deviation value for each column for each
#' subset
#' @importFrom stats sd
#' @family functions to evaluate samples
#' @family functions to evaluate numbers
#' @export
evaluate_sd <- function(i, pheno){
  stopifnot(sum(lengths(i))== nrow(pheno))
  # Distribution of sd
  num <- is_num(pheno)
  original_sd <- apply(pheno[, num, drop = FALSE], 2, sd, na.rm = TRUE)
  sd_group <- tapply(pheno, batch_names(i), sd, na.rm = TRUE, default = 0L)
  evaluate_helper(t(t(sd_group)), original_sd)
}

#' Evaluates the mean of the numeric values
#'
#' Looks for the mean of the numeric values
#' @param i List of indices
#' @param pheno Data.frame with information about the samples
#' @return A matrix with the mean value for each column for each subset
#' @family functions to evaluate samples
#' @family functions to evaluate numbers
#' @export
evaluate_mean <- function(i, pheno) {
  stopifnot(sum(lengths(i))== nrow(pheno))
  # Calculates the distribution
  num <- is_num(pheno)
  original_mean <- colMeans(pheno[, num, drop = FALSE], na.rm = TRUE)
  # Calculates for each subset
  mean_group <- tapply(pheno, batch_names(i), mean, na.rm = TRUE, default = 0L)
  evaluate_helper(t(t(mean_group)), original_mean)
}

#' Evaluate median absolute deviation
#'
#' Looks for the median absolute deviation values in each subgroup
#' @inheritParams evaluate_mean
#' @return A vector with the mean difference between the median absolute deviation
#' of each group and the original mad
#' @importFrom stats mad
#' @family functions to evaluate samples
#' @family functions to evaluate numbers
#' @export
evaluate_mad <- function(i, pheno) {
  stopifnot(sum(lengths(i))== nrow(pheno))
  # Calculates the distribution
  num <- is_num(pheno)
  original_mad <- apply(pheno[, num, drop = FALSE], 2, mad, numeric(1L), na.rm = TRUE)
  # Calculates for each subset
  mad_group <- tapply(pheno, batch_names(i), mad, na.rm = TRUE, default = 0L)
  evaluate_helper(t(t(mad_group)), original_mad)
}

