is_num <- function(x, ...) {
  if (ncol(x) == 1) {
    apply(x, 2, is.numeric)
  } else {
    vapply(x, is.numeric, logical(1L))
  }
}


omit <- function(pheno, omit){
  # Omit columns
  if (!is.null(omit)) {
    pheno[, !colnames(pheno) %in% omit, drop = FALSE]
  } else {
    pheno
  }
}



summary_num <- function(pheno) {
  diff <- matrix(0, ncol = ncol(pheno), nrow = 5)
  rownames(diff) <- c("mean", "sd", "mad", "na", "entropy")
  colnames(diff) <- colnames(pheno)
  diff
}

check_sizes <- function(size_data, n_batch, size_batch){
  size_batch_min <- ceiling(size_data/n_batch)
  n_batch_max <- ceiling(size_data/size_batch)
  if (size_batch >= size_batch_min && n_batch >= n_batch_max) {
    return(TRUE)
  }
  FALSE
}



mean_difference <- function(differences, subset_ind, eval_n) {
  # Calculate the score for each subset by variable
  apply(differences, 3, function(x) {
    x <- rbind(x, "ind" = 0)
    x <- insert(x, subset_ind, name = "ind")
    colSums(x, na.rm = TRUE)/eval_n
  })
}
