#' Evaluates the mean of the numeric values
#'
#' Looks for the standard deviation of the numeric values
#' @param i List of indices
#' @param pheno Data.frame with the samples
#' @return A matrix with the standard deviation value for each column for each
#' subset
#' @importFrom stats sd
#' @export
evaluate_sd <- function(i, pheno){
  stopifnot(sum(lengths(i))== nrow(pheno))
  # Distribution of sd
  num <- vapply(pheno, is.numeric, logical(1L))
  original_sd <- vapply(pheno[, num, drop = FALSE], sd, numeric(1L), na.rm = TRUE)
  out_sd <- lapply(i, function(x){
    vapply(droplevels(pheno[x, num, drop = FALSE]), sd, numeric(1L), na.rm = TRUE)
  })
  sd_group <- t(simplify2matrix(out_sd))
  evaluate_helper(sd_group, original_sd)
}

#' Evaluates the mean of the numeric values
#'
#' Looks for the mean of the numeric values
#' @param i List of indices
#' @param pheno Data.frame with information about the samples
#' @return A matrix with the mean value for each column for each subset
#' @export
evaluate_mean <- function(i, pheno) {
  stopifnot(sum(lengths(i))== nrow(pheno))
  # Calculates the distribution
  num <- vapply(pheno, is.numeric, logical(1L))
  original_mean <- colMeans(pheno[, num, drop = FALSE], na.rm = TRUE)
  # Calculates for each subset
  out_n <- lapply(i, function(x){
    vapply(droplevels(pheno[x, num, drop = FALSE]), mean, numeric(1L), na.rm = TRUE)
  })
  # Compres it
  mean_group <- t(simplify2matrix(out_n))
  evaluate_helper(mean_group, original_mean)
}

#' Evaluate median absolute deviation
#'
#' Looks for the median absolute deviation values in each subgroup
#' @inheritParams evaluate_mean
#' @return A vector with the mean difference between the median absolute deviation
#' of each group and the original mad
#' @importFrom stats mad
#' @export
evaluate_mad <- function(i, pheno) {
  stopifnot(sum(lengths(i))== nrow(pheno))
  # Calculates the distribution
  num <- vapply(pheno, is.numeric, logical(1L))
  original_mad <- vapply(pheno[, num, drop = FALSE], mad, numeric(1L), na.rm = TRUE)
  # Calculates for each subset
  out_n <- lapply(i, function(x){
    vapply(droplevels(pheno[x, num, drop = FALSE]), mad, numeric(1L), na.rm = TRUE)
  })
  # Compres it
  mad_group <- t(simplify2matrix(out_n))
  evaluate_helper(mad_group, original_mad)
}

