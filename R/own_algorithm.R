#' Calculates the entropy
#'
#' Calculates the entropy of a category. It uses the amount of categories to
#' scale between 0 and 1.
#' @param x A character or vector with two or more categories
#' @return The numeric value of the Shannon entropy
#' @export
#' @examples
#' entropy(c("H", "T", "H", "T"))
entropy <- function(x){
  n <- length(unique(x))
  prob <- table(x)/length(x)
  -sum(prob*log(prob, n))
}

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
  pheno_o <- pheno[, !omit %in% colnames(pheno)]

  # Find the numeric values
  num <- vapply(pheno_o, is.numeric, logical(1L))

  # Compare with the optimum (the original distribution)
  original_n <- vapply(pheno_o[, num], mean, numeric(1L), na.rm = TRUE)
  original_n_sd <- vapply(pheno_o[, num], sd, numeric(1L), na.rm = TRUE)

  # Calculate the entropy for the categorical values
  original_e <- vapply(droplevels(pheno_o[, !num]), entropy, numeric(1L))
  # Remove those that are different in each sample (Hopefully just the name of the sample)
  remove_e <- original_e == 1

  message()
  for (x in seq_len(iterations)) {

    i <- create_subset(size.batch, batches, nrow(pheno_o))
    opt_e <- .evaluate_cat(i, pheno_o[, !num], remove_e)
    opt_n <- .evaluate_num(i, pheno_o[, num], original_n, original_n_sd)

    # Minimize the value
    opt_o <- abs(sum(opt_n, opt_e))
    if (opt_o <= opt){
      opt <- opt_o
      val <- i # store in a different site
    }
  }
  val
}

#' Create index of subsets of a data
#'
#' @param size.subset A numeric value with the amount of samples per batch
#' @param n A numeric value with the number of batchs
#' @param size.data A numeric value of the amount of samples to distribute
#' @return A random list of indices of the samples
#' @export
#' @examples
#' create_subset(50, 2, 100)
create_subset <- function(size.subset, n, size.data) {
  size <- size.subset
  opt_s <- size.data/n
  stopifnot(size.subset*n >= size.data)
  # Create the subsets
  i <- vector("list", length = n)
  vec <- seq_len(size.data)
  for(j in seq_len(n)){
    s <- min(opt_s, size)
    out <- sample(vec, size = s)
    vec <- vec[!vec %in% out]
    i[[j]] <- out
  }
  names(i) <- paste0("SubSet", seq_len(n))
  i
}


#' Evaluates the mean of the numeric values
#' @param i List of indices
#' @param pheno Data.frame with the samples
#' @return A Matrix with the sd value for each column
#' @importFrom stats sd
#' @export
evaluate_sd <- function(i, pheno){
  stopifnot(sum(lengths(i))== nrow(pheno))
  # Distribution of sd
  out_n_sd <- sapply(i, function(x){
    vapply(droplevels(pheno[x, ]), sd, numeric(1L), na.rm = TRUE)
  })
  t(out_n_sd)
}

#' Evaluates the mean of the numeric values
#' @param i List of indices
#' @param pheno Data.frame with the samples
#' @return A Matrix with the mean value for each column
#' @export
evaluate_mean <- function(i, pheno) {
  stopifnot(sum(lengths(i))== nrow(pheno))
  # Calculates the distribution
  out_n <- sapply(i, function(x){
    vapply(droplevels(pheno[x, ]), mean, numeric(1L), na.rm = TRUE)
  })
  t(out_n)
}

#' Name the batch
#'
#' Given an index return the name of the batches the samples are in
#' @param i A list of numeric indices of the data
#' @return A character vector with the names of the batch for each sample
#' @export
batch_names <- function(i) {
  xy <- seq_along(i)
  isub <- lapply(xy, function(x) {
    rep_len(names(i)[x], length(i[[x]]))
  })
  isubNam <- unlist(isub, use.names = FALSE)
  isub <- unlist(i, use.names = FALSE)
  isubNam[isub]
}

# Function that takes the result of indexes and substracts the intended goal
evaluate_helper <- function(x, original_x){
  out <- sweep(x, 2, original_x, "-")
  out <- colMeans(out, na.rm = TRUE)
  sum(abs(out), na.rm = TRUE)
}

# A internal version where the precalculated data is provided
.evaluate_num <- function(i, pheno, original_n, original_n_sd) {

  # Evaluate mean
  m <- evaluate_mean(i, pheno)
  opt_m <- evaluate_helper(m, original_n)

  # Evaluate sd
  s <- evaluate_sd(i, pheno)
  opt_s <- evaluate_helper(s, original_n_sd)

  sum(opt_m, opt_s)
}


#' Evaluate numbers
#'
#' @param i list of numeric indices of the data.frame
#' @param pheno Data.frame
#' @return Value to minimize
#' @export
evaluate_num <- function(i, pheno) {

  # Compare with the optimum (the original distribution)
  original_n <- vapply(pheno, mean, numeric(1L), na.rm = TRUE)
  original_n_sd <- vapply(pheno, sd, numeric(1L), na.rm = TRUE)

  .evaluate_num(i, pheno, original_n, original_n_sd)
}

.evaluate_cat <- function(i, pheno, remove_e) {
  # Calculate the entropy for the subsets
  out_e <- sapply(i, function(x){
    vapply(droplevels(pheno[x, ]), entropy, numeric(1L))
  })
  out_e <- t(out_e)

  # Compare with the optimum 1 == random; 0 == all the same
  res_e <- 1-colMeans(out_e[, !remove_e], na.rm = TRUE)
  # Value to optimize
  opt_e <- sum(res_e, na.rm = TRUE)
  opt_e
}

#' Evaluate category
#'
#' @param i list of numeric indices of the data.frame
#' @param pheno Data.frame
#' @return Value to minimize
#' @export
evaluate_cat <- function(i, pheno) {
  num <- vapply(pheno, is.numeric, logical(1L))
  # Calculate the entropy for the categorical values
  original_e <- vapply(droplevels(pheno[, !num]), entropy, numeric(1L))
  # Remove those that are different in each sample (Hopefully just the name of the sample)
  remove_e <- original_e == 1
  .evaluate_cat(i, pheno[, !num], remove_e)
}
