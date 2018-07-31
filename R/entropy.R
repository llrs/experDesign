#' Calculates the entropy
#'
#' Calculates the entropy of a category. It uses the amount of categories to
#' scale between 0 and 1.
#' @param x A character or vector with two or more categories
#' @return The numeric value of the shannon entropy scaled between 0 and 1.
#' @note It omits the \code{NA} if present.
#' @export
#' @examples
#' entropy(c("H", "T", "H", "T"))
#' entropy(c("H", "T", "H", "T", "H", "H", "H"))
#' entropy(c("H", "T", "H", "T", "H", "H", NA))
#' entropy(c("H", "T", "H", "T", "H", "H"))
#' entropy(c("H", "H", "H", "H", "H", "H", NA))
entropy <- function(x){
  x <- x[!is.na(x)]
  n <- length(unique(x))
  if (n == 1L) {
    return(0L)
  }
  prob <- table(x)/length(x)
  -sum(prob*log(prob, n))
}

#' Evaluate the dispersion of NAs
#'
#' Looks how are \code{NA} distributed in each subset
#' @param i list of numeric indices of the data.frame
#' @param pheno Data.frame
#' @return The optimum value to reduce
#' @export
evaluate_na <- function(i, pheno) {
  mean_nas <- vapply(pheno, function(x){mean(is.na(x))}, numeric(1L))
  nas <- .evaluate_na(i, pheno, mean_nas)
  evaluate_helper(nas, mean_nas)
}


.evaluate_na <- function(i, pheno, mean_nas) {
  stopifnot(sum(lengths(i)) == nrow(pheno))
  out <- sapply(i, function(x){colSums(is.na(pheno[x, , drop = FALSE]))})
  t(out)

}



simplify2matrix <- function(l) {
  stopifnot(length(unique(lengths(l))) == 1)
  u <- unlist(l)

  m <- matrix(u, ncol = length(l))
  colnames(m) <- names(l)
  rownames(m) <- names(l[[1]])
  m
}
