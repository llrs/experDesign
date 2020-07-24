#' Calculates the entropy
#'
#' Calculates the entropy of a category. It uses the amount of categories to
#' scale between 0 and 1.
#' @param x A character or vector with two or more categories
#' @return The numeric value of the Shannon entropy scaled between 0 and 1.
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
  - sum(prob*log(prob, n))
}

#' Evaluate the dispersion of NAs
#'
#' Looks how are \code{NA} distributed in each subset
#' @param i list of numeric indices of the data.frame
#' @param pheno Data.frame
#' @return The optimum value to reduce
#' @family functions to evaluate samples
#' @family functions to evaluate categories
#' @family functions to evaluate numbers
#' @export
#' @examples
#' samples <- 10
#' m <- matrix(rnorm(samples), nrow = samples)
#' m[sample(seq_len(samples), size = 5), ] <- NA # Some NA
#' i <- create_subset(samples, 3, 4) # random subsets
#' evaluate_na(i, m)
evaluate_na <- function(i, pheno) {
  stopifnot(sum(lengths(i)) == nrow(pheno))
  orig_nas <- colSums(is.na(pheno))

  orig_nas <- orig_nas/length(i)
  out <- lapply(i, function(x){colSums(is.na(pheno[x, , drop = FALSE]))})
  nas <- t(simplify2matrix(out))
  evaluate_helper(nas, orig_nas)
}


# Function like simplify2array but it always return a matrix
simplify2matrix <- function(l) {
  stopifnot(length(unique(lengths(l))) == 1)
  u <- unlist(l)

  m <- matrix(u, ncol = length(l))
  colnames(m) <- names(l)
  rownames(m) <- names(l[[1]])
  m
}
