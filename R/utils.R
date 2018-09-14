is_num <- function(x, ...) {
  if (ncol(x) == 1) {
    apply(x, 2, is.numeric)
  } else {
    sapply(x, is.numeric)
  }
}


omit <- function(pheno, omit){
  # Omit columns
  if (!is.null(omit)){
    pheno[, !colnames(pheno) %in% omit, drop = FALSE]
  } else {
    pheno
  }
}
