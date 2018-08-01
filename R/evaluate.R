# A function to calculate the difference between a matrix and the original
# dataset
evaluate_helper <- function(x, original_x){
  stopifnot(ncol(x) == length(original_x))
  out <- sweep(x, 2, original_x, "-")
  colMeans(abs(out), na.rm = TRUE)
}

insert <- function(matrix, vector, name) {
  if (is.matrix(vector)){
    nam <- colnames(vector)
  } else {
    nam <- names(vector)
  }
  matrix[name, nam] <- vector
  matrix
}

#' Evaluate each variable provided
#'
#' @param pheno Data
#' @return A matrix with the values
#' @export
evaluate_orig <- function(pheno) {

  original <- matrix(0, ncol = ncol(pheno), nrow = 5)
  rownames(original) <- c("mean", "sd", "mad", "na", "entropy")
  colnames(original) <- colnames(pheno)

  na_orig <- vapply(pheno, function(x){sum(is.na(x))}, numeric(1L))
  original <- insert(original, na_orig, "na")

  num <- vapply(pheno, is.numeric, logical(1L))

  # Numeric data
  if (sum(num) >= 1) {
    pheno_num <- pheno[, num, drop = FALSE]

    subset_num <- vapply(pheno_num, function(y) {
      c("sd" = sd(y, na.rm = TRUE),
        "mean" = mean(y, na.rm = TRUE),
        "mad" = mad(y, na.rm = TRUE))
    }, numeric(3L))
    original <- insert(original, subset_num, c("sd", "mean", "mad"))
  }
  # Categorical data
  if (sum(!num) >= 1){
    pheno_cat <- pheno[, !num, drop = FALSE]
    entropy_orig <- vapply(pheno_cat, entropy, numeric(1L))
    original <- insert(original, entropy_orig, "entropy")
  }

  original
}

#' Evaluates a data.frame
#'
#' @param i Index
#' @inheritParams evaluate_orig
#' @export
evaluate_index <- function(i, pheno) {

  num <- vapply(pheno, is.numeric, logical(1L))

  diff <- matrix(0, ncol = ncol(pheno), nrow = 5)
  rownames(diff) <- c("mean", "sd", "mad", "na", "entropy")
  colnames(diff) <- colnames(pheno)

  out <- sapply(i, function(x){

    subset_na <- vapply(pheno[x, ], function(y){sum(is.na(x))}, numeric(1L))
    diff1 <- insert(diff, subset_na, "na")

    if (sum(num) >= 1) {
      pheno_num <- pheno[x, num, drop = FALSE]

      subset_num <- vapply(pheno_num, function(y) {
        c("sd" = sd(y, na.rm = TRUE),
          "mean" = mean(y, na.rm = TRUE),
          "mad" = mad(y, na.rm = TRUE))
      }, numeric(3L))
      diff1 <- insert(diff1, subset_num, c("sd", "mean", "mad"))
    }

    if (sum(!num) >= 1){
      pheno_cat <- droplevels(pheno[x, !num, drop = FALSE])
      subset_entropy <- vapply(pheno_cat, entropy, numeric(1L))
      diff1 <- insert(diff1, subset_entropy, "entropy")
    }

    diff1
  }, simplify = "array")

  dimnames(out) <- list("stat" = rownames(diff),
                        "variables" = colnames(pheno),
                        "subgroups" = names(i))
  out
}
