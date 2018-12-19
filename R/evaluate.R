# A function to calculate the difference between a matrix and the original
# dataset
evaluate_helper <- function(x, original_x){
  stopifnot(ncol(x) == length(original_x))
  out <- sweep(x, 2, original_x, "-")
  colMeans(abs(out), na.rm = TRUE)
}

# To insert a vector or a matrix inside another matrix
insert <- function(matrix, vector, name) {
  if (is.matrix(vector)) {
    nam <- colnames(vector)
  } else {
    nam <- names(vector)
  }
  matrix[name, nam] <- vector
  matrix
}

#' Evaluate each variable provided
#'
#' Measure some summary statistics of the whole cohort of samples
#' @param pheno Data.frame with information about the samples
#' @return A matrix with the mean, standard deviation, MAD values of the
#' numeric variables, the entropy of the categorical, and the amount of
#' \code{NA} per variable.
#' @family functions to evaluate samples
#' @export
evaluate_orig <- function(pheno) {

  stopifnot(!is.null(colnames(pheno)))
  original <- matrix(0, ncol = ncol(pheno), nrow = 5)
  rownames(original) <- c("mean", "sd", "mad", "na", "entropy")
  colnames(original) <- colnames(pheno)

  na_orig <- colSums(is.na(pheno))
  original <- insert(original, na_orig, "na")

  num <- is_num(pheno)

  # Numeric data
  if (sum(num) >= 1) {
    pheno_num <- pheno[, num, drop = FALSE]

    subset_num <- apply(pheno_num, 2, function(y) {
      c("sd" = sd(y, na.rm = TRUE),
        "mean" = mean(y, na.rm = TRUE),
        "mad" = mad(y, na.rm = TRUE))
    })
    original <- insert(original, subset_num, c("sd", "mean", "mad"))
  }
  # Categorical data
  if (sum(!num) >= 1) {
    pheno_cat <- pheno[, !num, drop = FALSE]
    entropy_orig <- apply(pheno_cat, 2, entropy)
    original <- insert(original, entropy_orig, "entropy")
  }

  original
}

#' Evaluates a data.frame
#'
#' Measures several indicators per group
#' @param i Index
#' @inheritParams evaluate_orig
#' @return An array of three dimensions with the mean, sd, and mad of the
#' numeric variables, the entropy of the categorical and the number of
#' \code{NA} by each subgroup.
#' @family functions to evaluate samples
#' @seealso If you have already an index you can use \code{\link{use_index}}
#' @export
evaluate_index <- function(i, pheno) {

  num <- is_num(pheno)

  diff <- matrix(0, ncol = ncol(pheno), nrow = 5)
  rownames(diff) <- c("mean", "sd", "mad", "na", "entropy")
  colnames(diff) <- colnames(pheno)
  ev_subset <- function(x){

    subset_na <- na_orig <- colSums(is.na(pheno[x, , drop = FALSE]))
    diff1 <- insert(diff, subset_na, "na")

    if (sum(num) >= 1) {
      pheno_num <- pheno[x, num, drop = FALSE]

      subset_num <- apply(pheno_num, 2, function(y) {
        c("sd" = sd(y, na.rm = TRUE),
          "mean" = mean(y, na.rm = TRUE),
          "mad" = mad(y, na.rm = TRUE))
      })
      diff1 <- insert(diff1, subset_num, c("sd", "mean", "mad"))
    }

    if (sum(!num) >= 1) {
      pheno_cat <- droplevels(pheno[x, !num, drop = FALSE])
      subset_entropy <- apply(pheno_cat, 2, entropy)
      diff1 <- insert(diff1, subset_entropy, "entropy")
    }

    diff1
  }

  out <- sapply(i, ev_subset, simplify = "array")

  dimnames(out) <- list("stat" = rownames(diff),
                        "variables" = colnames(pheno),
                        "subgroups" = names(i))
  out
}
