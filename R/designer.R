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
#' @importFrom methods is
#' @export
design <- function(pheno, size.batch, omit = NULL, iterations = 500) {
  opt <- Inf

  # Calculate batches
  batches <- ceiling(nrow(pheno)/size.batch)

  # Omit columns
  if (!is.null(omit)){
    pheno_o <- pheno[, !colnames(pheno) %in% omit, drop = FALSE]
  } else {
    pheno_o <- pheno
  }

  mean_nas <- vapply(pheno_o, function(x){mean(is.na(x))}, numeric(1L))

  # Find the numeric values
  num <- vapply(pheno_o, is.numeric, logical(1L))
  dates <- vapply(pheno_o, function(x){methods::is(x, "Date")}, logical(1L))
  if (any(dates)) {
    warning("The dates will be treat as categories")
  }

  thereis_numbers <- sum(num) >= 1
  thereis_category <- sum(!num) >= 0

  if (thereis_numbers) {
    # Compare with the optimum (the original distribution)
    original_n <- vapply(pheno_o[, num, drop = FALSE], mean, numeric(1L), na.rm = TRUE)
    original_n_sd <- vapply(pheno_o[, num, drop = FALSE], sd, numeric(1L), na.rm = TRUE)
  } else if (thereis_category) {
    # Calculate the entropy for the categorical values
    original_e <- vapply(droplevels(pheno_o[, !num]), entropy, numeric(1L))
    # Remove those that are different in each sample (Hopefully just the name of the sample)
    remove_e <- original_e == 1
  }

  for (x in seq_len(iterations)) {
    i <- create_subset(size.batch, batches, nrow(pheno_o))

    if (thereis_category) {
      opt_e <- .evaluate_cat(i, pheno_o[, !num, drop = FALSE], remove_e)
      opt_i <- evaluate_independence(i, pheno_o[, !num, drop = FALSE])
    } else if (thereis_numbers) {
      opt_n <- .evaluate_num(i, pheno_o[, num, drop = FALSE], original_n, original_n_sd)
    }

    opt_nas <- evaluate_na(i, pheno_o)

    # Minimize the value
    if (thereis_numbers & thereis_category){
      opt_o <- sum(opt_nas, opt_n, opt_e, opt_i, na.rm = TRUE)
    } else if (thereis_category) {
      opt_o <- sum(opt_nas, opt_e, opt_i, na.rm = TRUE)
    } else if (thereis_numbers) {
      opt_o <- sum(opt_nas, opt_n)
    }

    # store index if "better"
    if (opt_o <= opt){
      opt <- opt_o
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
  size.batch <- size.batch-controls
  design(pheno, size.batch, omit = NULL, iterations = 500)
}

