#' Design a batch experiment
#'
#' Given some samples it distribute them in several batches, trying to have
#' equal number of samples per batch. It can handle both numeric and
#' categorical data.
#' @param pheno Data.frame with the sample information.
#' @param size_subset Numeric value of the number of sample per batch.
#' @param omit Name of the columns of the `pheno` that will be omitted.
#' @param iterations Numeric value of iterations that will be performed.
#' @param name A character used to name the subsets, either a single one or a
#' vector the same size as `n`.
#' @return The indices of which samples go with which batch.
#' @seealso The `evaluate_*` functions and [create_subset()].
#' @importFrom methods is
#' @export
#' @examples
#' data(survey, package = "MASS")
#' index <- design(survey[, c("Sex", "Smoke", "Age")], size_subset = 50,
#'                 iterations = 50)
#' index
design <- function(pheno, size_subset, omit = NULL, iterations = 500,
                   name = "SubSet") {
  stopifnot(is.numeric(size_subset) && is.finite(size_subset))
  stopifnot(length(dim(pheno)) == 2)
  stopifnot(is.numeric(iterations) && is.finite(iterations))
  stopifnot(is.character(name))
  opt <- Inf

  # Calculate batches
  size_data <- nrow(pheno)
  if (size_subset >= size_data) {
    stop("All the data can be done in one batch.", call. = FALSE)
  }
  batches <- optimum_batches(size_data, size_subset)

  if (!valid_sizes(size_data, size_subset, batches)) {
    stop("Please provide a higher number of batches or more samples per batch.",
         call. = FALSE)
  }

  pheno_o <- omit(pheno, omit)

  original_pheno <- evaluate_orig(pheno_o)
  original_pheno["na", ] <- original_pheno["na", ]/batches

  # Find the numeric values
  dates <- vapply(pheno_o, function(x){methods::is(x, "Date")}, logical(1L))
  if (any(dates)) {
    warning("The dates will be treat as categories")
  }

  num <- is_num(pheno_o)
  # Numbers are evaluated 4 times, and categories only 3
  # check this on evaluate_index
  eval_n <- ifelse(num, 4, 3)
  size_batches <- internal_batches(size_data, size_subset, batches)
  for (x in seq_len(iterations)) {
    i <- create_index(size_data, size_batches, batches, name = name)

    subsets <- evaluate_index(i, pheno_o)
    # Evaluate the differences between the subsets and the originals
    differences <- abs(sweep(subsets, c(1, 2), original_pheno))
    # Add the independence of the categorical values
    subset_ind <- evaluate_independence(i, pheno_o)
    # Calculate the score for each subset by variable
    meanDiff <- mean_difference(differences, subset_ind, eval_n)
    # Minimize the value
    optimize <- sum(rowMeans(abs(meanDiff)))

    # store index if "better"
    if (optimize <= opt) {
      opt <- optimize
      val <- i
    }
  }
  val
}

#' Design a batch experiment with experimental controls
#'
#' To ensure that the batches are comparable some samples are processed in each
#' batch. This function allows to take into account that effect.
#' It uses the most different samples as controls as defined with [extreme_cases()].
#' @inheritParams design
#' @param controls The numeric value of the amount of technical controls per
#' batch.
#' @return A index with some samples duplicated in the batches
#' @seealso [design()], [extreme_cases()].
#' @export
#' @examples
#' samples <- data.frame(L = letters[1:25], Age = rnorm(25))
#' index <- replicates(samples, 5, controls = 2, iterations = 10)
#' head(index)
replicates <- function(pheno, size_subset, controls, omit = NULL,
                       iterations = 500){
  stopifnot(is.numeric(size_subset) && is.finite(size_subset))
  stopifnot(length(dim(pheno)) == 2)
  stopifnot(is.numeric(iterations) && is.finite(iterations))

  size_data <- nrow(pheno)
  if (size_subset >= size_data) {
    stop("All the data can be done in one batch.", call. = FALSE)
  }
  if (size_subset < controls) {
    stop("The controls are technical controls for the batches.\n\t",
         "They cannot be above the number of samples per batch.", call. = FALSE)
  }
  size_subset <- size_subset - controls
  values <- extreme_cases(pheno = pheno, size = controls, omit = omit)
  batches <- design(pheno, size_subset, omit = omit, iterations = iterations)

  for (b in seq_along(batches)) {
    val <- c(batches[[b]], values[!values %in% batches[[b]]])
    batches[[b]] <- sort(val)
  }
  batches
}
