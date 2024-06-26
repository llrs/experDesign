#' Distribute the sample on the plate
#'
#' This function assumes that to process the batch the samples are distributed in
#' a plate with a grid scheme.
#' @inheritParams design
#' @param index A list with the samples on each subgroup, as provided from
#' [design()] or [replicates()].
#' @param remove_positions Character, name of positions to be avoided in the grid.
#' @param rows Character, name of the rows to be used.
#' @param columns Character, name of the rows to be used.
#' @return The indices of which samples go with which batch.
#' @export
#' @examples
#' data(survey, package = "MASS")
#' index <- design(survey[, c("Sex", "Smoke", "Age")], size_subset = 50,
#'                 iterations = 10)
#' index2 <- spatial(index, survey[, c("Sex", "Smoke", "Age")], iterations = 10)
#' head(index2)
spatial <- function(index, pheno, omit = NULL, remove_positions = NULL, rows = LETTERS[1:5],
         columns = 1:10, iterations = 500) {

  stopifnot(length(dim(pheno)) == 2)
  stopifnot(is_numeric(iterations))

  position <- handle_positions(rows, columns, remove_positions)
  if (length(position) < max(lengths(index))) {
    stop("The size for the batch is smaller than the samples it must contain.",
         "\n\tPlease check the rows and columns or how you created the index.",
         call. = FALSE)
  }

  opt <- Inf

  # Calculate batches
  batches <- length(index)
  pheno_o <- omit(pheno, omit)

  # Use index to duplicate samples in case the index comes from replicates.
  # It also adds the name of the batch
  pheno_o <- inspect(index, pheno_o)
  i2 <- translate_index(index)

  num <- is_num(pheno_o)
  original_pheno <- .evaluate_orig(pheno_o, num)
  original_pheno["na", ] <- original_pheno["na", ]/batches

  # Find the numeric values
  dates <- vapply(pheno_o, is_date, logical(1L))
  if (any(dates)) {
    warning("The dates will be treat as categories")
  }

  eval_n <- evaluations(num)

  for (j in seq_len(iterations)) {

    i <- create_index4index(i2, name = position)
    meanDiff <- .check_index(i, pheno_o, num, eval_n, original_pheno)
    # Minimize the value
    optimize <- sum(rowMeans(abs(meanDiff)))

    # store index if "better"
    if (optimize <= opt) {
      opt <- optimize
      val <- i
    }
  }

  if (any(lengths(val) > length(index))) {
    stop("The spatial distribution is impossible:",
         "It allocated more sample to the previous index than possible.",
         call. = FALSE)
  }
  # Return positions ordered by row and column
  m <- match(position_name(rows, columns)$name, names(val))
  val[m[!is.na(m)]]
}

handle_positions <- function(rows, columns, remove_positions) {

  if (is.null(rows) || length(rows) == 0) {
    stop("Please provide at least one row.", call. = FALSE)
  }
  if (is.null(columns) || length(columns) == 0) {
    stop("Please provide at least one column.", call. = FALSE)
  }

  positions <- position_name(rows, columns)

  k_position <- !positions$name %in% remove_positions
  k_rows <- !positions$row %in% remove_positions
  k_columns <- !positions$column %in% remove_positions
  mix_positions <- any(!k_position) && (any(!k_rows) || any(!k_columns))
  if (mix_positions) {
    warning("There is a mix of specific positions and rows or columns.")
  }
  p <- positions[k_position & k_rows & k_columns, ,drop = FALSE]

  if (nrow(p) == 0L) {
    stop("No position is left. Did you remove too many positions?",
         call. = FALSE)
  }

  if (length(remove_positions) > (nrow(positions) - nrow(p))) {
    stop("Unrecognized position to remove.",
         "\n\tCheck that it is a combination of rows and columns: A1, A3, or full rows and columns ...",
         call. = FALSE)
  }
  p$name
}