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
  out_n_sd <- sapply(i, function(x){
    vapply(droplevels(pheno[x, , drop = FALSE]), sd, numeric(1L), na.rm = TRUE)
  })
  t(out_n_sd)
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
  out_n <- sapply(i, function(x){
    vapply(droplevels(pheno[x, , drop = FALSE]), mean, numeric(1L), na.rm = TRUE)
  })
  t(out_n)
}


# A function to calculate the difference between a matrix and the original
# dataset
evaluate_helper <- function(x, original_x){
  stopifnot(ncol(x) == length(original_x))
  out <- sweep(x, 2, original_x, "-")
  out <- colMeans(abs(out), na.rm = TRUE)
  sum(out, na.rm = TRUE)
}

# A internal version where the precalculated data is provided
.evaluate_num <- function(i, pheno, original_n, original_n_sd) {

  # Evaluate mean
  m <- evaluate_mean(i, pheno)
  opt_m <- evaluate_helper(m, original_n)

  # Evaluate sd
  s <- evaluate_sd(i, pheno)
  opt_s <- evaluate_helper(s, original_n_sd)

  sum(opt_m, opt_s)
}

#' Evaluate numbers
#'
#' Evaluate how far are each subset of the desired goal.
#' @param i list of numeric indices of the data.frame
#' @param pheno Data.frame
#' @return Value to minimize, summarizing the difference with the desired output
#' @export
evaluate_numbers <- function(i, pheno) {

  # Compare with the optimum (the original distribution)
  original_n <- vapply(pheno, mean, numeric(1L), na.rm = TRUE)
  original_n_sd <- vapply(pheno, sd, numeric(1L), na.rm = TRUE)

  .evaluate_num(i, pheno, original_n, original_n_sd)
}
