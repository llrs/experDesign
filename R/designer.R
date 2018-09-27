#' Design a batch experiment
#'
#' Given some samples it distribute them in several batches, trying to have
#' equal number of samples per batch. It can handle both numeric and
#' categorical data.
#' @param pheno Data.frame with the sample information.
#' @param size.batch Numeric value of the number of sample per batch
#' @param omit Name of the columns of the pheno that will be omitted
#' @param iterations Numeric value of iterations that will be performed
#' @return The indices of which samples go with which batch
#' @seealso The \code{evaluate_*} functions and \code{\link{create_subset}}
#' @importFrom methods is
#' @export
design <- function(pheno, size.batch, omit = NULL, iterations = 500) {
  opt <- Inf

  # Calculate batches
  batches <- ceiling(nrow(pheno)/size.batch)

  pheno_o <- omit(pheno, omit)

  original_pheno <- evaluate_orig(pheno_o)
  original_pheno["na", ] <- original_pheno["na", ]/batches

  # Find the numeric values
  dates <- vapply(pheno_o, function(x){methods::is(x, "Date")}, logical(1L))
  if (any(dates)) {
    warning("The dates will be treat as categories")
  }

  num <- is_num(pheno)
  # Numbers are evaluated 4 times, and categories only 3
  # check this on evaluate_index
  eval_n <- ifelse(num, 4, 3)

  for (x in seq_len(iterations)) {
    i <- create_subset(size.batch, batches, nrow(pheno_o))

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
  message("Minimum value reached: ", round(opt))
  val
}

#' Design a batch experiment with experimental controls
#'
#' To ensure that the batches are comparable some samples are processed in each
#' batch. This function allows to take into account that effect
#' @inheritParams design
#' @param controls The numeric values of technical controls per batch
#' @return The distribution without the controls
#' @seealso \code{\link{design}}
#' @export
replicates <- function(pheno, size.batch, controls, omit = NULL,
                       iterations = 500){
  stopifnot(is.numeric(size.batch))
  stopifnot(is.numeric(controls))
  size.batch <- size.batch - controls
  design(pheno, size.batch, omit = omit, iterations = iterations)
}

