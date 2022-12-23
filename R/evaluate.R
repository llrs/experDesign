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
  if (!.check_data(pheno)) {
    warning("There might be some problems with the data use check_data().")
  }
  num <- is_num(pheno)
  .evaluate_orig(pheno, num)
}

.evaluate_orig <- function(pheno, num) {
  stopifnot(!is.null(colnames(pheno)))
  original <- empty_res(pheno, num)
  original <- insert(original, colSums(is.na(pheno)), "na")

  ev_subset(x = seq_len(nrow(pheno)), pheno = pheno, numeric = num, diff = original)
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
  if (!.check_data(pheno)) {
    warning("There might be some problems with the data use check_data().", call. = FALSE)
  }
  .evaluate_index(i, pheno, is_num(pheno))

}


.evaluate_index <- function(i, pheno, num) {
  d <- empty_res(pheno, num)
  if (sum(!num) > 1) {
    d <- cbind(d, mix_cat = rep(0, nrow(d)))
  }

  out <- sapply(i, ev_subset, pheno = pheno, numeric = num, diff = d, simplify = "array")

  dimnames(out) <- list("stat" = rownames(d),
                        "variables" = colnames(pheno),
                        "subgroups" = names(i))
  out

}

ev_subset <- function(x, pheno, numeric, diff){

  subset_na <- na_orig <- colSums(is.na(pheno[x, , drop = FALSE]))
  diff1 <- insert(diff, subset_na, "na")

  # Look for eval_n <- ifelse(num, 4, 3) if any change happens on numeric
  # or categorical tests.
  if (sum(numeric) >= 1) {
    pheno_num <- pheno[x, numeric, drop = FALSE]
    subset_num <- apply(pheno_num, 2, function(y) {
      c("sd" = sd(y, na.rm = TRUE),
        "mean" = mean(y, na.rm = TRUE),
        "mad" = mad(y, na.rm = TRUE))
    })
    diff1 <- insert(diff1, subset_num, c("sd", "mean", "mad"))
  }

  if (sum(!numeric) >= 1) {
    pheno_cat <- droplevels(pheno[x, !numeric, drop = FALSE])
    if (sum(!numeric) > 1) {
      pheno_cat$mix_cat <- apply(pheno_cat, 1, paste0, collapse = "")
    }

    subset_entropy <- apply(pheno_cat, 2, entropy)
    diff1 <- insert(diff1, subset_entropy, "entropy")
  }

  diff1
}
