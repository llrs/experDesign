#' Create index of subsets of a data
#'
#' Index of the samples grouped by batches.
#' @param size.subset A numeric value with the amount of samples per batch
#' @param n A numeric value with the number of batches
#' @param size.data A numeric value of the amount of samples to distribute
#' @return A random list of indices of the samples
#' @seealso \code{\link{batch_names}}, \code{\link{use_index}} if you already
#' have a factor to be used as index.
#' @export
#' @examples
#' index <- create_subset(100, 50, 2)
create_subset <- function(size.data, size.subset = NULL, n = NULL) {

  if (is.null(size.subset) && is.null(n)) {
    stop("Either size.subset or n should numeric")
  }

  if (is.null(n)) {
    n <- ceiling(size.data/size.subset)
  } else if (is.null(size.subset)) {
    size.subset <- ceiling(size.data/n)
  }


  if (size.subset*n - size.data < 0) {
    stop("Please provide a higher number of batches or more samples per batch")
  }
  .create_index(size.subset, n, size.data)
}

.create_index <- function(size.subset, n, size.data) {
  size <- size.subset
  opt_s <- ceiling(size.data/n)

  # Create the subsets
  i <- vector("list", length = n)
  vec <- seq_len(size.data)
  for (j in seq_len(n)) {
    s <- min(opt_s, size, length(vec))
    out <- sample(vec, size = s)
    vec <- vec[!vec %in% out]
    i[[j]] <- out
  }
  # stopifnot(sum(lengths(i)) == size.data)
  names(i) <- paste0("SubSet", seq_len(n))
  i
}

#' Convert a factor to index
#'
#' Convert a given factor to an accepted index
#' @param x A character or a factor to be used as index
#' @export
#' @seealso  You can use \code{\link{evaluate_index}} to evaluate how good an
#' index is
#' @examples
#' plates <- c("P1", "P2", "P1", "P2", "P2", "P3", "P1", "P3", "P1", "P1")
#' use_index(plates)
use_index <- function(x){
  split(seq_along(x), x)
}

#
#' Name the batch
#'
#' Given an index return the name of the batches the samples are in
#' @param i A list of numeric indices.
#' @return A character vector with the names of the batch for each sample
#' @seealso \code{\link{create_subset}}
#' @export
#' @examples
#' index <- create_subset(50, 2, 100)
#' batch <- batch_names(index)
#' head(batch)
batch_names <- function(i) {
  xy <- seq_along(i)
  isub <- lapply(xy, function(x) {
    rep_len(names(i)[x], length(i[[x]]))
  })
  isubNam <- unlist(isub, use.names = FALSE)
  isub <- unlist(i, use.names = FALSE)
  isubNam[isub]
}
