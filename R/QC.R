#' Select the subset of extreme cases to evaluation
#' @param size The number of samples to subset.
#' @inheritParams design
#' @export
extreme_cases <- function(pheno, size, omit = NULL, iterations= 500){

  opt <- 0

  # Calculate batches

  pheno_o <- omit(pheno, omit)

  original_pheno <- evaluate_orig(pheno_o)
  original_pheno["na", ] <- original_pheno["na", ]

  # Find the numeric values
  dates <- vapply(pheno_o, function(x){methods::is(x, "Date")}, logical(1L))
  if (any(dates)) {
    warning("The dates will be treat as categories")
  }

  num <- is_num(pheno)
  # Numbers are evaluated 4 times, and categories only 2 (no independence)
  # check this on evaluate_index
  eval_n <- ifelse(num, 4, 2)

  for (x in seq_len(iterations)) {
    i <- create_subset(size, 1, nrow(pheno_o))

    subsets <- evaluate_index(i, pheno_o)
    # Evaluate the differences between the subsets and the originals
    differences <- abs(sweep(subsets, c(1, 2), original_pheno))

    # Calculate the score for each subset by variable
    meanDiff <- colSums(differences, na.rm = TRUE)/eval_n

    # Minimize the value
    optimize <- colMeans(abs(meanDiff), na.rm = TRUE)

    # store index if "better"
    if (optimize > opt){
      opt <- optimize
      val <- i
    }
  }
  message("Maximum value reached: ", round(opt))
  val
}

#' Seek optimum size for a batch
#'
#' Calculates the number of samples to representative of most of the variance
#' of their categorical variables.
#' @param pheno A \code{data.frame} with the information about the samples.
#' @return A number for the number of samples needed.
# For a qualitative it looks to have at least one value of each level for each category
# For a quantitative variable it looks to have a different range
#' @export
optimum_size <- function(pheno) {
  num <- is_num(pheno)
  # pheno_num <- pheno[, num]
  pheno_cat <- pheno[, !num, drop = FALSE]
  uni <- function(x){
    y <- unique(x)
    length(y[!is.na(y)])
  }
  vec <- apply(pheno_cat, 2, uni)
  max(c(ceiling(prod(vec)^(1/length(vec))), max(vec)))
}


#' Sub sample each batch
#'
#' To do quality control of each batch select the most representative of each batch
#' @param each Logical value if you want to extract the samples of each batch or not.
#' @inheritParams extreme_cases
#' @inheritParams design
function(pheno, index, size, each = FALSE, iterations = 500) {

}
