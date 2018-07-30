#' Calculates the entropy
#'
#' Calculates the entropy of a category. It uses the amount of categories to
#' scale between 0 and 1.
#' @param x A character or vector with two or more categories
#' @return The numeric value of the Shannon entropy
#' @export
#' @examples
#' entropy(c("H", "T", "H", "T"))
entropy <- function(x){
  n <- length(unique(x))
  prob <- table(x)/length(x)
  -sum(prob*log(prob, n))
}
