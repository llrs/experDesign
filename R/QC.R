#' @export
extreme_cases <- function(pheno, size, omit = NULL, iterations= 500){

  opt <- 0

  pheno <- omit(pheno, omit)

  # Find the numeric values
  dates <- vapply(pheno, function(x){methods::is(x, "Date")}, logical(1L))
  if (any(dates)) {
    warning("The dates will be treat as categories")
  }

  original_pheno <- evaluate_orig(pheno)

  for (x in seq_len(iterations)) {
    i <- create_subset(size, 1, nrow(pheno))
    subsets <- evaluate_index(i, pheno)
    # Evaluate if it is more disperse
    differences <- abs(sweep(subsets, c(1, 2), original_pheno))
    dimnam <- dimnames(differences)
    dim(differences) <- dim(differences)[1:2]
    dimnames(differences) <- dimnam[1:2]
    # Calculate the score for each subset by variable
    optimize <- sum(colSums(differences[c("sd", "mad"), ]),  differences["entropy", ])

    # store index if "better"
    if (optimize > opt){
      opt <- optimize
      val <- i
    }
  }
  val
}

#' Seek optimum size for a batch
#'
#' Calculates the number of samples to representative of most of the variance.
#' @param pheno A \code{data.frame} with the information about the samples.
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
