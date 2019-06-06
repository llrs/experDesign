#' Design a batch experiment
#'
#' Given some samples it distribute them in several batches, trying to have
#' equal number of samples per batch. It can handle both numeric and
#' categorical data.
#' @param pheno Data.frame with the sample information.
#' @param size_subset Numeric value of the number of sample per batch
#' @param omit Name of the columns of the pheno that will be omitted
#' @param iterations Numeric value of iterations that will be performed
#' @return The indices of which samples go with which batch
#' @seealso The \code{evaluate_*} functions and \code{\link{create_subset}}
#' @importFrom methods is
#' @export
design <- function(pheno, size_subset, omit = NULL, iterations = 500) {
  opt <- Inf

  # Calculate batches
  size_data <- nrow(pheno)

  batches <- optimum_batches(size_data, size_subset)
  size_subset_optimum <- optimum_subset(size_data, batches)

  if (!check_sizes(size_data, size_subset_optimum, batches)) {
    stop("Please provide a higher number of batches or more samples per batch.")
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

  for (x in seq_len(iterations)) {
    i <- create_subset(size_data, size_subset_optimum, batches)

    subsets <- evaluate_index(i, pheno_o)
    # Evaluate the differences between the subsets and the originals
    differences <- abs(sweep(subsets, c(1, 2), original_pheno))
    # Add the independence of the categorical values
    subset_ind <- evaluate_independence(i, pheno_o)

    # Calculate the score for each subset by variable
    meanDiff <- apply(differences, 3, function(x) {

      x <- rbind(x, "ind" = 0)
      x <- insert(x, subset_ind, name = "ind")
      colSums(x, na.rm = TRUE)/eval_n
    })

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
#' batch. This function allows to take into account that effect
#' @inheritParams design
#' @param controls The numeric value of the amount of technical controls per
#' batch.
#' @return A index with some samples duplicated in the batches
#' @seealso \code{\link{design}}
#' @export
#' @examples
#' samples <- data.frame(L = letters[1:25], Age = rnorm(25))
#' index <- replicates(samples, 5, controls = 2, iterations = 10)
replicates <- function(pheno, size_subset, controls, omit = NULL,
                       iterations = 500){
  stopifnot(is.numeric(size_subset))
  stopifnot(is.numeric(controls))

  if (size_subset < controls) {
    stop("The controls are technical controls for the batches.\n\t",
         "They cannot be above the number of samples per batch.", call. = FALSE)
  }
  size_subset <- size_subset - controls
  values <- extreme_cases(pheno = pheno, size = controls, omit = omit)
  batches <- design(pheno, size_subset, omit = omit, iterations = iterations)

  for (b in seq_along(batches)) {
    batches[[b]] <- c(batches[[b]], values[!values %in% batches[[b]]])
  }
  batches
}
