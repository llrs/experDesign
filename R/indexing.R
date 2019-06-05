#' Create index of subsets of a data
#'
#' Index of the samples grouped by batches.
#' @param size_subset A numeric value with the amount of samples per batch
#' @param n A numeric value with the number of batches
#' @param size_data A numeric value of the amount of samples to distribute
#' @return A random list of indices of the samples
#' @seealso \code{\link{batch_names}}, \code{\link{use_index}} if you already
#' have a factor to be used as index.
#' @export
#' @examples
#' index <- create_subset(100, 50, 2)
create_subset <- function(size_data, size_subset = NULL, n = NULL) {

  if (is.null(size_subset) && is.null(n)) {
    stop("Either size.subset or n should numeric")
  }

  if (is.null(n)) {
    n <- ceiling(size_data/size_subset)
  } else if (is.null(size_subset)) {
    size_subset <- ceiling(size_data/n)
  }


  if (!check_sizes(size_data, size_subset, n)) {
    stop("Please provide a higher number of batches or more samples per batch.")
  }
  .create_index(size_data, size_subset, n)
}

.create_index <- function(size_data, size_subset, n) {

  names_batches <- paste0("SubSet", seq_len(n))
  min_subset <- floor(size_data/n)

  # Create the subsets
  i <- vector("list", length = n)
  vec <- seq_len(size_data)
  for (j in seq_len(n)) {
    lv <- length(vec)
    s <- ifelse(size_subset*j <= lv, size_subset, min(min_subset, lv))
    out <- sample(vec, size = s)
    vec <- vec[!vec %in% out]
    i[[j]] <- out
  }
  names(i) <- names_batches
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
#' @return A character vector with the names of the batch for each the index.
#' @seealso \code{\link{create_subset}}
#' @export
#' @examples
#' index <- create_subset(50, 2, 100)
#' batch <- batch_names(index)
#' head(batch)
batch_names <- function(i) {
  rep(names(i), lengths(i))
}
