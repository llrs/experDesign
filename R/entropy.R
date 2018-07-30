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
