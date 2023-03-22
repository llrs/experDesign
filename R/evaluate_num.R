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
#' @examples
#' data(survey, package = "MASS")
#' index <- design(survey[, c("Sex", "Smoke", "Age")], size_subset = 50,
#'                 iterations = 50)
#' # Note that categorical columns will be omitted:
#' evaluate_sd(index, survey[, c("Sex", "Smoke", "Age")])
evaluate_sd <- function(i, pheno){
  stopifnot(sum(lengths(i)) == nrow(pheno))
  # Distribution of sd
  num <- is_num(pheno)
  pheno_o <- pheno[, num, drop = FALSE]
  original_sd <- apply(pheno_o, 2, sd, na.rm = TRUE)
  i <- batch_names(i)
  sd_group <- apply(pheno_o, 2, function(x) {
    tapply(x, i, sd, na.rm = TRUE, default = 0L)})
  evaluate_helper(sd_group, original_sd)
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
#' @examples
#' data(survey, package = "MASS")
#' index <- design(survey[, c("Sex", "Smoke", "Age")], size_subset = 50,
#'                 iterations = 50)
#' # Note that categorical columns will be omitted:
#' evaluate_mean(index, survey[, c("Sex", "Smoke", "Age")])
evaluate_mean <- function(i, pheno) {
  stopifnot(sum(lengths(i)) == nrow(pheno))
  # Calculates the distribution
  num <- is_num(pheno)
  pheno_o <- pheno[, num, drop = FALSE]
  original_mean <- colMeans(pheno_o, na.rm = TRUE)
  # Calculates for each subset
  i <- batch_names(i)
  mean_group <- apply(pheno_o, 2, function(x) {
    tapply(x, i, mean, na.rm = TRUE, default = 0L)
  })
  evaluate_helper(mean_group, original_mean)
}

#' Evaluate median absolute deviation
#'
#' Looks for the median absolute deviation values in each subgroup.
#' @inheritParams evaluate_mean
#' @return A vector with the mean difference between the median absolute deviation
#' of each group and the original mad.
#' @importFrom stats mad
#' @family functions to evaluate samples
#' @family functions to evaluate numbers
#' @export
#' @examples
#' data(survey, package = "MASS")
#' index <- design(survey[, c("Sex", "Smoke", "Age")], size_subset = 50,
#'                 iterations = 50)
#' # Note that categorical columns will be omitted:
#' evaluate_mad(index, survey[, c("Sex", "Smoke", "Age")])
evaluate_mad <- function(i, pheno) {
  stopifnot(sum(lengths(i)) == nrow(pheno))
  # Calculates the distribution
  num <- is_num(pheno)
  pheno_o <- pheno[, num, drop = FALSE]
  original_mad <- apply(pheno_o, 2, mad, numeric(1L), na.rm = TRUE)
  # Calculates for each subset
  i <- batch_names(i)
  mad_group <- apply(pheno_o, 2, function(x) {
    tapply(x, i, mad, na.rm = TRUE, default = 0L)
    })
  evaluate_helper(mad_group, original_mad)
}

