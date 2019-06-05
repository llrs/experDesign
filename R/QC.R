#' Select the subset of extreme cases to evaluation
#'
#' Subset some samples that are mostly different.
#' @param size The number of samples to subset.
#' @inheritParams qcSubset
#' @inheritParams design
#' @return A vector with the number of the rows that are selected.
#' @seealso \code{\link{optimum_size}}
#' @export
extreme_cases <- function(pheno, size, omit = NULL, each = FALSE, iterations= 500){

  # Calculate batches
  pheno_o <- omit(pheno, omit)

  original_pheno <- evaluate_orig(pheno_o)

  # Find the numeric values
  dates <- vapply(pheno_o, function(x){methods::is(x, "Date")}, logical(1L))
  if (any(dates)) {
    warning("The dates will be treat as categories")
  }

  nSamples <- nrow(pheno)
  opt <- -Inf

  for (x in seq_len(iterations)) {
    i <- .create_index(nSamples, size, 1)

    subsets <- evaluate_index(i, pheno_o)
    # Evaluate the differences between the subsets and the originals
    differences <- drop(abs(sweep(subsets, c(1, 2), original_pheno)))
    differences <- differences[-c(1, 4), ]
    differences["entropy", ] <- differences["entropy", ]/0.5

    # Maximize the entropy and the dispersion
    optimize <- sum(colSums(differences))

    # store index if "better"
    if (optimize > opt) {
      opt <- optimize
      val <- i
    }


    if (x == iterations) {
      warning("Maximum number of iterations reached\n")
    }
  }
  message("Maximum value reached: ", round(sum(abs(opt))))
  unlist(val, use.names = FALSE)
}

#' Seek optimum size for a batch
#'
#' Calculates the number of samples that encode all the qualitative variables.
#' @param pheno A \code{data.frame} with the information about the samples.
#' @param omit The name of the columns to omit from the data.frame.
#' @return A number for the number of samples needed. At most it can be half of
#' the samples.
# For a qualitative it looks to have at least one value of each level for each category
# For a quantitative variable it looks to have a different range
#' @export
optimum_size <- function(pheno, omit = NULL) {
  pheno <- omit(pheno, omit)
  num <- is_num(pheno)

  # Different subsets
  pheno_cat <- pheno[, !num, drop = FALSE]
  pheno_num <- unique(pheno[, num, drop = FALSE])
  nSamples <- nrow(pheno)
  uPheno <- unique(pheno_cat)
  nUniqSamples <- nrow(uPheno)
  r <- range(2, ceiling(nUniqSamples/2), ceiling(nSamples/2))
  stopifnot(max(r) <= ceiling(nSamples/2))
  max(r)
}

#' Random subset
#'
#' Select randomly some samples
#' @param index A list of indices indicating which samples go to which subset
#' @param size The number of samples that should be taken.
#' @param each A logical value if the subset should be taken from all the
#' samples or for each batch.
#' @export
#' @examples
#' index <- create_subset(100, 50, 2)
#' QC_samples <- qcSubset(index, 10)
#' QC_samplesBatch <- qcSubset(index, 10, TRUE)
qcSubset <- function(index, size, each = FALSE) {

  if (!is.logical(each)) {
    stop("each should be either TRUE or FALSE")
  }

  if (!is.numeric(size)) {
    stop("size should be a numeric value")
  }

  if (!is.list(index)) {
    stop("index should be a list with numeric values")
  }

  if (each) {
    out <- lapply(index, sample, size = size)
  } else {
    out <- sample(unlist(index, recursive = FALSE), size = size)
  }
  out
}

#' Check index
#'
#' Report the statistics for each subset and variable compared to the original
#' @inheritParams design
#' @inheritParams qcSubset
#' @return A matrix with the differences with the original data
#' @export
check_index <- function(pheno, index, omit = NULL) {
  batches <- length(index)

  pheno_o <- omit(pheno, omit)
  num <- is_num(pheno_o)
  # Numbers are evaluated 4 times, and categories only 3
  # check this on evaluate_index
  eval_n <- ifelse(num, 4, 3)

  original_pheno <- evaluate_orig(pheno_o)
  original_pheno["na", ] <- original_pheno["na", ]/batches

  subsets <- evaluate_index(index, pheno_o)
  # Evaluate the differences between the subsets and the originals
  differences <- abs(sweep(subsets, c(1, 2), original_pheno))
  # Add the independence of the categorical values
  subset_ind <- evaluate_independence(index, pheno_o)

  # Calculate the score for each subset by variable
  meanDiff <- apply(differences, 3, function(x) {

    x <- rbind(x, "ind" = 0)
    x <- insert(x, subset_ind, name = "ind")
    colSums(x, na.rm = TRUE)/eval_n
  })
  meanDiff
}
