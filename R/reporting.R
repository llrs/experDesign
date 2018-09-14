#' Inspect the index
#'
#' Given the index and the data of the samples append the batch assignment
#' @param i List of indices of samples per batch
#' @param pheno Data.frame with the sample information.
#' @param omit Name of the columns of the pheno that will be omitted
#' @return The data.frame
#' @export
inspect <- function(i, pheno, omit = NULL) {
  batch <- batch_names(i)

  # Omit columns
  if (!is.null(omit)){
    pheno_o <- pheno[, !colnames(pheno) %in% omit, drop = FALSE]
  } else {
    pheno_o <- pheno
  }

  cbind(pheno_o, batch)
}


#' Distribution by batch
#'
#' Checks if all the values are maximally distributed in the several batches
#' @param report A data.frame which must contain a batch column. Which can be
#' obtained with \code{\link{inspect}}
#' @param column The name of the column one wants to inspect
#' @return \code{TRUE} if the values are maximal distributed, otherwise
#' \code{FALSE}
#' @export
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
