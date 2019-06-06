#' Optimum values for batches
#'
#' Calculates the optimum values for number of batches or size of the batches.
#' If you need to do several batches it can be better to distribute it evently
#' and add replicates.
#' @return
#' \describe{
#' \item{\code{optimum_batches}}{A numeric value with the number of batches to
#' use.}
#' \item{\code{optimum_subset}}{A numeric value with the maximum number of samples per batch of the data.}
#' \item{\code{sizes_batches}}{A numeric vector with the number of samples in each batch.}
#' }
#' @param size_data A numeric value of the number of samples to use
#' @param batches A numeric value of the number of batches
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
  ceiling(size_data/size_subset)
}

#' @export
#' @rdname optimum
optimum_subset <- function(size_data, batches) {
  ceiling(size_data/batches)
}


# Return the size of each batch so that there is less problems
#' @export
#' @rdname optimum
sizes_batches <- function(size_data, size_subset, batches) {
  # Look for all combination of sizes for that number of batches
  pos <- seq(from = 0, to = batches)
  factors <- t(expand.grid(pos, pos))
  factors <- factors[, colSums(factors) == batches, drop = FALSE]

  # Look for those that get equal to size_data
  out <- t(factors) %*% c(size_subset, size_subset-1)
  pos <- which(out[, 1] == size_data)[1] # To get the first one
  # If the size cannot be equal to the data return the original size_subset
  if (is.na(pos)) {
    return(size_subset)
  }
  rep(c(size_subset, size_subset-1), factors[, pos])
}
