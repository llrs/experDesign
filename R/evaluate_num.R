
#' Evaluates the mean of the numeric values
#' @param i List of indices
#' @param pheno Data.frame with the samples
#' @return A Matrix with the sd value for each column
#' @importFrom stats sd
#' @export
evaluate_sd <- function(i, pheno){
  stopifnot(sum(lengths(i))== nrow(pheno))
  # Distribution of sd
  out_n_sd <- sapply(i, function(x){
    vapply(droplevels(pheno[x, ]), sd, numeric(1L), na.rm = TRUE)
  })
  t(out_n_sd)
}

#' Evaluates the mean of the numeric values
#' @param i List of indices
#' @param pheno Data.frame with the samples
#' @return A Matrix with the mean value for each column
#' @export
evaluate_mean <- function(i, pheno) {
  stopifnot(sum(lengths(i))== nrow(pheno))
  # Calculates the distribution
  out_n <- sapply(i, function(x){
    vapply(droplevels(pheno[x, ]), mean, numeric(1L), na.rm = TRUE)
  })
  t(out_n)
}


evaluate_helper <- function(x, original_x){
  out <- sweep(x, 2, original_x, "-")
  out <- colMeans(out, na.rm = TRUE)
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
#' @param i list of numeric indices of the data.frame
#' @param pheno Data.frame
#' @return Value to minimize
#' @export
evaluate_num <- function(i, pheno) {

  # Compare with the optimum (the original distribution)
  original_n <- vapply(pheno, mean, numeric(1L), na.rm = TRUE)
  original_n_sd <- vapply(pheno, sd, numeric(1L), na.rm = TRUE)

  .evaluate_num(i, pheno, original_n, original_n_sd)
}
