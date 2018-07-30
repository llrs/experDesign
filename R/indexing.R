#' Create index of subsets of a data
#'
#' Index of the samples grouped by batches.
#' @param size.subset A numeric value with the amount of samples per batch
#' @param n A numeric value with the number of batchs
#' @param size.data A numeric value of the amount of samples to distribute
#' @return A random list of indices of the samples
#' @export
#' @examples
#' create_subset(50, 2, 100)
create_subset <- function(size.subset, n, size.data) {
  size <- size.subset
  opt_s <- size.data/n
  stopifnot(size.subset*n >= size.data)
  # Create the subsets
  i <- vector("list", length = n)
  vec <- seq_len(size.data)
  for(j in seq_len(n)){
    s <- min(opt_s, size)
    out <- sample(vec, size = s)
    vec <- vec[!vec %in% out]
    i[[j]] <- out
  }
  names(i) <- paste0("SubSet", seq_len(n))
  i
}



#' Name the batch
#'
#' Given an index return the name of the batches the samples are in
#' @param i A list of numeric indices of the data
#' @return A character vector with the names of the batch for each sample
#' @export
batch_names <- function(i) {
  xy <- seq_along(i)
  isub <- lapply(xy, function(x) {
    rep_len(names(i)[x], length(i[[x]]))
  })
  isubNam <- unlist(isub, use.names = FALSE)
  isub <- unlist(i, use.names = FALSE)
  isubNam[isub]
}
