is_num <- function(x, ...) {
  if (ncol(x) == 1) {
    apply(x, 2, is.numeric)
  } else {
    sapply(x, is.numeric)
  }
}
