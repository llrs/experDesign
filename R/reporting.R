#' Inspect the index
#'
#' Given the index and the data of the samples append the batch assignment
#' @param i List of indices of samples per batch
#' @param pheno Data.frame with the sample information.
#' @param omit Name of the columns of the `pheno` that will be omitted.
#' @param index_name Column name of the index of the resulting data.frame.
#' @return The data.frame with a new column batch with the name of the batch the sample goes to.
#' @export
#' @examples
#' data(survey, package = "MASS")
#' columns <- c("Sex", "Age", "Smoke")
#' index <- design(pheno = survey[, columns], size_subset = 70,
#'                 iterations = 10)
#' batches <- inspect(index, survey[, columns])
#' head(batches)
inspect <- function(i, pheno, omit = NULL, index_name = "batch") {

  consistent_index(i, pheno)

  batch <- batch_names(translate_index(i))
  pheno <- apply_index(pheno, i)
  # Remove old rows (only needed to inspect changes)
  pheno[ , "old_rows"] <- NULL

  # Omit columns
  if (!is.null(omit)) {
    pheno_o <- pheno[, !colnames(pheno) %in% omit, drop = FALSE]
  } else {
    pheno_o <- pheno
  }
  add_column(pheno_o, values = batch, name = index_name)
}


#' Distribution by batch
#'
#' Checks if all the values are maximally distributed in the several batches.
#' Aimed for categorical variables.
#' @param report A data.frame which must contain a batch column. Which can be
#' obtained with [inspect()].
#' @param column The name of the column one wants to inspect.
#' @return `TRUE` if the values are maximal distributed, otherwise `FALSE`.
#' @export
#' @examples
#' data(survey, package = "MASS")
#' columns <- c("Sex", "Age", "Smoke")
#' nas <- c(137, 70) # Omit rows with NA to avoid warnings in design
#' index <- design(pheno = survey[-nas, columns], size_subset = 70,
#'                 iterations = 10)
#' batches <- inspect(index, survey[, columns])
#' distribution(batches, "Sex")
#' distribution(batches, "Smoke")
distribution <- function(report, column){
  stopifnot(length(column) == 1)
  nBatch <- length(unique(report$batch))

  distr <- table(report[[column]], report$batch)

  nCategory <- table(report[[column]])
  batchesCategory <- apply(distr, 1, function(x){sum(x != 0)})

  # Samples which are not on all batches and in less than the number of samples
  # per category
  interesting <- batchesCategory != nBatch & batchesCategory < nCategory

  if (any(interesting)) {
    warning(column, ": ", sum(interesting),
            " categories not totally distributed in all batches")
    return(FALSE)
  }
  TRUE
}
