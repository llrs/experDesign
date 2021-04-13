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
#' `NA` per variable.
#' @family functions to evaluate samples
#' @export
#' @examples
#' data(survey, package = "MASS")
#' evaluate_orig(survey[, c("Sex", "Age", "Smoke")])
evaluate_orig <- function(pheno) {

  stopifnot(!is.null(colnames(pheno)))
  original <- summary_num(pheno)

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
#' @return An array of three dimensions with the mean, standard deviation
#' ([sd()]), and median absolute deviation ([mad()]) of the numeric variables, the
#' entropy of the categorical and the number of `NA` by each subgroup.
#' @family functions to evaluate samples
#' @seealso If you have already an index you can use [use_index()].
#' @export
#' @examples
#' data(survey, package = "MASS")
#' index <- create_subset(nrow(survey), 50, 5)
#' ev_index <- evaluate_index(index, survey[, c("Sex", "Smoke")])
#' ev_index["entropy", , ]
evaluate_index <- function(i, pheno) {
  if (!(is.matrix(pheno) || is.data.frame(pheno))) {
    stop("Please provide a matrix or a data.frame")
  }
  num <- is_num(pheno)

  diff <- summary_num(pheno)
  ev_subset <- function(x){

    subset_na <- na_orig <- colSums(is.na(pheno[x, , drop = FALSE]))
    diff1 <- insert(diff, subset_na, "na")

    # Look for eval_n <- ifelse(num, 4, 3) if any change happens on numeric
    # or categorical tests.
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
