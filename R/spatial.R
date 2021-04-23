#' Distribute the sample on the plate
#'
#' This function assumes that to process the batch the samples are distributes in
#' a plate. Sometimes you know in advance the
#' @inheritParams design
#' @param index A list with the samples on each subgroup, as provided from
#' `design()` or `replicates()`.
#' @param remove_positions Character, name of positions.
#' @param rows Character, name of the rows to be used.
#' @param columns Character, name of the rows to be used.
#' @return The indices of which samples go with which batch.
#' @export
#' @examples
#' data(survey, package = "MASS")
#' index <- design(survey[, c("Sex", "Smoke", "Age")], size_subset = 50,
#'                 iterations = 25)
#' index2 <- spatial(index, survey[, c("Sex", "Smoke", "Age")], iterations = 25)
#' head(index2)
spatial <- function(index, pheno, omit = NULL, remove_positions = NULL, rows = LETTERS[1:5],
         columns = 1:10, iterations = 500) {

  stopifnot(length(dim(pheno)) == 2)
  stopifnot(is.numeric(iterations) && is.finite(iterations))

  nrow <- length(rows)
  ncol <- length(columns)

  if (is.null(rows) | length(rows) == 0) {
    stop("Please provide at least one row.", call. = FALSE)
  }
  if (is.null(columns) | length(columns) == 0) {
    stop("Please provide at least one column.", call. = FALSE)
  }
  if ((nrow*ncol-length(remove_positions)) < max(lengths(index))) {
    stop("The size for the batch is smaller than the samples it must contain.",
         "\n\tPlease check the rows and columns or how you created the index.",
         call. = FALSE)
  }

  plate <- matrix(nrow = nrow, ncol = ncol, dimnames = list(rows, columns))
  positions <- position_name(rows, columns)
  if (any(!remove_positions %in% positions$name)) {
    stop("Unrecognized position to remove.",
         "\n\tCheck that it is a combination of rows and columns: A1, A3...",
         call. = FALSE)
  }

  position <- positions$name[!positions$name %in% remove_positions]

  opt <- Inf

  # Calculate batches
  batches <- length(index)
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

  # Use index to duplicate samples in case the index comes from replicates.
  pheno_o <- pheno_o[unlist(index), ]
  old_rows <- round(as.numeric(rownames(pheno_o)))
  rownames(pheno_o) <- NULL
  new_rows <- as.numeric(rownames(pheno_o))
  size_data <- sum(lengths(index))
  size_subset <- batches
  batches <- length(position)
  size_batches <- internal_batches(size_data, size_subset, batches)
  for (x in seq_len(iterations)) {
    i <- create_index(size_data, size_batches, batches, name = position)

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
  translate_index(val, old_rows, new_rows)
}
