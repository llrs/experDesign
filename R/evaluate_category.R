#' Evaluate entropy
#'
#' Looks if the nominal or character columns are equally distributed according
#' to the entropy and taking into account the independence between batches.
#' If any column is different in each row it is assumed to be the sample names
#' and thus omitted.
#' @param i list of numeric indices of the data.frame
#' @param pheno Data.frame with information about the samples
#' @return Value to minimize
#' @family functions to evaluate samples
#' @family functions to evaluate categories
#' @export
#' @examples
#' data(survey, package = "MASS")
#' index <- design(survey[, c("Sex", "Smoke", "Age")], size_subset = 50,
#'                 iterations = 50)
#' # Note that numeric columns will be omitted:
#' evaluate_entropy(index, survey[, c("Sex", "Smoke", "Age")])
evaluate_entropy <- function(i, pheno) {

  num <- is_num(pheno)
  stopifnot(sum(!num) >= 1)
  pheno_o <- droplevels(pheno[, !num, drop = FALSE])
  # Calculate the entropy for the categorical values
  original_e <- vapply(pheno_o, function(x){length(unique(x))/length(x)}, numeric(1L))
  # Remove those that are different in each sample (Hopefully just the name of the sample)
  remove_e <- original_e == 1
  .evaluate_cat(i, pheno_o, remove_e)
}

.evaluate_cat <- function(i, pheno, remove_e) {
  # Calculate the entropy for the subsets
  out_e <- lapply(i, function(x){
    vapply(pheno[x, , drop = FALSE], entropy, numeric(1L))
  })
  out_e <- t(simplify2matrix(out_e))

  # Compare with the optimum 1 == random; 0 == all the same
  out <- 1 - colMeans(out_e[, !remove_e, drop = FALSE], na.rm = TRUE)
  abs(out)
}

#' Compare independence by chisq.test
#'
#' Looks the independence between the categories and the batches.
#' @param i Index of subsets.
#' @param pheno A data.frame with the information about the samples.
#' @return Returns a vector with the p-values of the chisq.test between the
#' category and the subset.
#' @importFrom stats chisq.test
#' @family functions to evaluate samples
#' @family functions to evaluate categories
#' @export
#' @examples
#' data(survey, package = "MASS")
#' index <- design(survey[, c("Sex", "Smoke", "Age")], size_subset = 50,
#'                 iterations = 50)
#' # Note that numeric columns will be omitted:
#' evaluate_independence(index, survey[, c("Sex", "Smoke", "Age")])
evaluate_independence <- function(i, pheno) {
  num <- is_num(pheno)

  stopifnot(sum(!num) >= 1)
  batches <- batch_names(i)
  .evaluate_ind(batches, pheno[unlist(i), !num, drop = FALSE])
}

.evaluate_ind <- function(batch, pheno) {
  vapply(pheno, function(x) {
    suppressWarnings(stats::chisq.test(table(batch, x))$p.value)
  }, numeric(1L))
}


#' Check experiment data
#'
#' In order to run a successful experiment a good design is needed even before measuring the data.
#' This functions checks several heuristics for a good experiment and warns if they are not found.
#' @param pheno Data.frame with the variables of each sample, one row one sample.
#' @param na.omit Check the effects of missing values too.
#' @return A logical value indicating if everything is alright (TRUE) or not (FALSE).
#' @export
#' @examples
#' rdata <- expand.grid(sex = c("M", "F"), class = c("lower", "median", "high"))
#' rdata2 <- rbind(rdata, rdata)
#' check_data(rdata2)
#' \donttest{
#' #Different warnings
#' check_data(rdata)
#' check_data(rdata[-c(1, 3), ])
#' data(survey, package = "MASS")
#' check_data(survey)
#' }
check_data <- function(pheno, na.omit = FALSE) {
  stopifnot(is.data.frame(pheno) || is.matrix(pheno), is_logical(na.omit))
  .check_data(pheno = pheno, na.omit = na.omit, verbose = TRUE)
}

.check_data <- function(pheno, na.omit = FALSE, verbose = FALSE) {
  stopifnot(is_logical(verbose))
  data_status <- TRUE
  num <- is_num(pheno)
  cat <- is_cat(pheno)
  # Check input data as factor, character or numbers (no data.frames or nested lists)
  if (sum(num + cat) != ncol(pheno)) {
    if (verbose) {
      warning("There are some columns of unidentified type. ",
              "Only accepts numeric or categorical values in a data.frame.", call. = FALSE)
    }
    data_status <- FALSE
  }

  # There should be at least one categorical column
  if (sum(cat) == 0) {
    if (verbose) {
      warning("No categorical values were found; numeric values are not checked here.",
              call. = FALSE)
    }
    return(data_status)
  }

  pairwise_colusion <- combn(names(pheno)[cat], 2, FUN = function(x) {
    y <- table(pheno[, x], useNA = if (!na.omit) "ifany")
    any(y == 0)
  })

  if (any(pairwise_colusion)) {
    if (isTRUE(verbose)) {
      warning("Two categorical variables don't have all the combinations.",
              call. = FALSE)
    }
    data_status <- FALSE
  }

  pheno_o <- droplevels(pheno[, cat, drop = FALSE])

  nas <- lapply(pheno_o, function(x){which(is.na(x))})
  if (any(lengths(nas) >= 1)) {
    if (verbose) {
      warning("Some values are missing.", call. = FALSE)
    }
    data_status <- if (!na.omit) FALSE
  }
  # Check if one variable has only one category
  l_unique <- lapply(pheno_o, table)
  # Omit variable names
  if (any(lengths(l_unique) == nrow(pheno_o))) {
    if (verbose) {
      warning("There is a variable with as many categories as samples. ",
              "Are these the sample names?", call. = FALSE)
    }
  }
  if (sum(lengths(l_unique) == nrow(pheno_o)) > 1) {
    if (verbose) {
      warning("Multiple variables with as many categories as rows.", call. = FALSE)
    }
    data_status <- FALSE
  }

  if (any(vapply(l_unique, function(x) {any(x == 1)}, FUN.VALUE = logical(1L)))) {
    if (verbose) {
      warning("There is a category with just one sample.", call. = FALSE)
    }
    data_status <- FALSE
  }
  # Check if the combinations of categories has only one replicate
  texts <- apply(pheno_o, 1, paste0, collapse = "")
  texts_freq <- table(texts)
  if (sum(cat) > 1 && any(texts_freq == 1)) {
    if (verbose) {
      warning("There is a combination of categories with no replicates; i.e. just one sample.", call. = FALSE)
    }
    data_status <- FALSE
  }
  data_status
}
