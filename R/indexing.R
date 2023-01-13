#' Create index of subsets of a data
#'
#' Index of the samples grouped by batches.
#' @param size_subset A numeric value with the amount of samples per batch.
#' @param n A numeric value with the number of batches.
#' @param size_data A numeric value of the amount of samples to distribute.
#' @param name A character used to name the subsets, either a single one or a
#' vector the same size as `n`.
#' @return A random list of indices of the samples.
#' @seealso [batch_names()], [use_index()] if you already
#' have a factor to be used as index.
#' @export
#' @examples
#' index <- create_subset(100, 50, 2)
create_subset <- function(size_data, size_subset = NULL, n = NULL, name = "SubSet") {

  if (is.null(size_subset) && is.null(n)) {
    stop("Either size.subset or n should numeric")
  }

  if (is.null(n)) {
    n <- optimum_batches(size_data, size_subset)
  }
  if (is.null(size_subset)) {
    size_subset <- optimum_subset(size_data, n)
  }

  if (!valid_sizes(size_data, size_subset, n)) {
    stop("Please provide a higher number of batches or more samples per batch.")
  }
  size_batches <- internal_batches(size_data, size_subset, n)
  create_index(size_data, size_batches, n, name)
}

# The workhorse function without any check
create_index <- function(size_data, size_batches, n, name = "SubSet") {
  # The size of each batch
  i <- distribute_samples(size_data, size_batches)
  names(i) <- id2batch_names(name, n)
  i
}

id2batch_names <- function(name, n) {
  if (length(name) != 1 && length(name) != n) {
    stop("Provide a single character or a vector the same size of the batches.",
         call. = FALSE)
  }
  if (length(name) == 1) {
    name <- paste0(name, seq_len(n))
  }
  name
}

distribute_samples <- function(size_data, size_subsets) {
  # Create the subsets
  i <- vector("list", length = length(size_subsets))
  vec <- seq_len(size_data)
  for (j in seq_along(size_subsets)) {
    out <- sort(sample(vec, size = size_subsets[j]))
    vec <- vec[!vec %in% out]
    i[[j]] <- out
  }
  i
}

#' Convert a factor to index
#'
#' Convert a given factor to an accepted index
#' @param x A character or a factor to be used as index
#' @export
#' @seealso  You can use [evaluate_index()] to evaluate how good an
#' index is. For the inverse look at  [batch_names()].
#' @examples
#' plates <- c("P1", "P2", "P1", "P2", "P2", "P3", "P1", "P3", "P1", "P1")
#' use_index(plates)
use_index <- function(x) {
  stopifnot(is.character(x))
  if (anyNA(x)) {
    warning("NAs present in the index. Some samples weren't assigned to a batch?")
  }
  .use_index(x)
}

.use_index <- function(x) {
  factors <- x
  factors[is.na(x)] <- "NA"
  split(seq_along(x), factors)
}

#' Name the batch
#'
#' Given an index return the name of the batches the samples are in
#' @param i A list of numeric indices.
#' @return A character vector with the names of the batch for each the index.
#' @seealso [create_subset()], for the inverse look at
#' [use_index()].
#' @export
#' @examples
#' index <- create_subset(100, 50, 2)
#' batch <- batch_names(index)
#' head(batch)
batch_names <- function(i) {
  names <- rep(names(i), lengths(i))
  names[order(unlist(i, use.names = FALSE))]
}
