#' Optimum values for batches
#'
#' Calculates the optimum values for number of batches or size of the batches.
#' If you need to do several batches it can be better to distribute it evenly
#' and add replicates.
#' @return
#' \describe{
#' \item{`optimum_batches`}{A numeric value with the number of batches to
#' use.}
#' \item{`optimum_subset`}{A numeric value with the maximum number of samples
#' per batch of the data.}
#' \item{`sizes_batches`}{A numeric vector with the number of samples in each
#' batch.}
#' }
#' @param size_data A numeric value of the number of samples to use.
#' @param batches A numeric value of the number of batches.
#' @inheritParams design
#' @examples
#' size_data <- 50
#' size_batch <- 24
#  # Calculates the optimum number of batches
#' (batches <- optimum_batches(size_data, size_batch))
#' # So now the best number of samples for each batch is less than the available
#' (size <- optimum_subset(size_data, batches))
#' # The distribution of samples per batch
#' sizes_batches(size_data, size, batches)
#' @name optimum
NULL

#' @export
#' @rdname optimum
optimum_batches <- function(size_data, size_subset) {
  check_number(size_data, "size_data")
  check_number(size_subset, "size_subset")
  ceiling(size_data/size_subset)
}

#' @export
#' @rdname optimum
optimum_subset <- function(size_data, batches) {
  check_number(size_data, "size_data")
  check_number(batches, "batches")
  ceiling(size_data/batches)
}


# Return the size of each batch so that there are less problems
#' @export
#' @rdname optimum
sizes_batches <- function(size_data, size_subset, batches) {
  check_number(size_data, "size_data")
  check_number(size_subset, "size_subset")
  check_number(batches, "batches")
  if (batches == 1) {
    stop("There should be more than one batch.", call. = FALSE)
  }
  if  (size_subset*batches < size_data) {
    stop("batches or size_subset is too small to fit all the samples.",
         call. = FALSE)
  }
  if  (sum(size_subset*seq_len(batches) > size_data) > 1) {
    stop("batches or size_subset could be reduced.",
         call. = FALSE)
  }

  if (!valid_sizes(size_data, size_subset, batches)) {
    stop("Please provide a higher number of batches or more samples per batch.",
         call. = FALSE)
  }
  out <- internal_batches(size_data, size_subset, batches)
  out <- unname(out)
  stopifnot(sum(out) == size_data)
  stopifnot(length(out) == batches)
  stopifnot(all(out <= size_subset))
  out
}

internal_batches <- function(size_data, size_subset, batches) {
  # If the data fits exactly there is no need for further calculations
  if (size_subset*batches == size_data) {
    return(rep(size_subset, length.out = batches))
  }

  if (batches == 1) {
    return(size_subset)
  }

  # If there are no remaining samples to allocate that's it
  if (size_subset*batches == size_data) {
    return(rep(size_subset, times = batches))
  }

  # Calculate the minimum number of samples per batch
  remaining <- size_data - size_subset*(batches - 1)

  # Look for the combination of samples that is less reductive
  s <- seq(from = remaining, to = size_subset)
  l <- rep(list(s), batches) # List of possibilities for each batch
  combn_sizes <- expand.grid(l) # All combinations
  combn_sizes <- as.matrix(combn_sizes)
  k <- rowSums(combn_sizes) == size_data
  combn_sizes <- combn_sizes[k, ]
  r <- apply(combn_sizes, 1, function(x){max(x) - min(x)})
  final_combn <- combn_sizes[r == min(r), ][1, ]
  sort(unlist(final_combn, FALSE, FALSE), decreasing = TRUE)
}

check_number <- function(x, name) {
  if (length(x) != 1 || !is.numeric(x)) {
    stop(name, " must be a single number.", call. = FALSE)
  }
}
