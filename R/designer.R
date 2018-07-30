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
#' @export
design <- function(pheno, size.batch, omit, iterations = 500) {
  opt <- Inf

  # Calculate batches
  batches <- ceiling(nrow(pheno)/size.batch)

  # Omit columns
  pheno_o <- pheno[, !colnames(pheno) %in% omit, drop = FALSE]

  # Find the numeric values
  num <- vapply(pheno_o, is.numeric, logical(1L))

  # Compare with the optimum (the original distribution)
  original_n <- vapply(pheno_o[, num, drop = FALSE], mean, numeric(1L), na.rm = TRUE)
  original_n_sd <- vapply(pheno_o[, num, drop = FALSE], sd, numeric(1L), na.rm = TRUE)

  # Calculate the entropy for the categorical values
  original_e <- vapply(droplevels(pheno_o[, !num]), entropy, numeric(1L))
  # Remove those that are different in each sample (Hopefully just the name of the sample)
  remove_e <- original_e == 1

  message()
  for (x in seq_len(iterations)) {
    i <- create_subset(size.batch, batches, nrow(pheno_o))
    opt_e <- .evaluate_cat(i, pheno_o[, !num, drop = FALSE], remove_e)
    opt_n <- .evaluate_num(i, pheno_o[, num, drop = FALSE], original_n, original_n_sd)
    opt_i <- evaluate_independence(i, pheno_o[, !num, drop = FALSE])

    # Minimize the value
    opt_o <- abs(sum(opt_n, opt_e, opt_i, na.rm = TRUE))
    if (opt_o <= opt){
      opt <- opt_o
      val <- i # store in a different site
    }
  }
  val
}

