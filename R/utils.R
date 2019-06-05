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
