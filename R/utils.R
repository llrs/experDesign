is_num <- function(x, ...) {
  if (is.null(ncol(x))) {
    is.numeric(x)
  } else if (ncol(x) == 1) {
    apply(x, 2, is.numeric)
  } else {
    vapply(x, is.numeric, logical(1L))
  }
}

is_date <- function(y) {
  methods::is(y, "Date") || inherits(y, "POSIXt")
}

f_check <- function(y){
  is_char <- is.character(y) || is.factor(y)
  is_char || is_date(y)
}

is_cat <- function(x, ...) {
  if (is.null(ncol(x))) {
    f_check(x)
  } else if (ncol(x) == 1) {
    apply(x, 2, f_check)
  } else {
    vapply(x, f_check, logical(1L))
  }
}


omit <- function(pheno, omit){
  # Omit columns
  if (!is.null(omit)) {
    pheno[, !colnames(pheno) %in% omit, drop = FALSE]
  } else {
    pheno
  }
}

translate_index <- function(index, old_position, new_position) {
  stopifnot(length(new_position) == length(old_position))
  stopifnot(sum(lengths(index)) == length(new_position))
  for (i in seq_along(index)) {
    index[[i]] <- old_position[new_position %in% index[[i]]]
  }
  index
}

position_name <- function(rows, columns) {
  positions <- expand.grid(rows, columns, stringsAsFactors = FALSE)
  positions$Var2 <- as.character(positions$Var2)
  positions$name <- apply(positions, 1, paste0, collapse = "")
  colnames(positions)[1:2] <- c("row", "column")
  positions
}

empty_res <- function(pheno, num) {
  if (is.null(ncol(pheno))) {
    ncol <- 1
    column <- "variable"
  } else {
    ncol <- ncol(pheno)
    column <- colnames(pheno)
  }
  if (sum(!num) > 1) {
    ncol <- ncol +1
    column <- c(column, "mix_cat")
  }


  diff <- matrix(0, ncol = ncol, nrow = 6)
  rownames(diff) <- c("mean", "sd", "mad", "na", "entropy", "independence")
  colnames(diff) <- column
  diff
}

valid_sizes <- function(size_data, size_subset, batches){
  n_batch_max <- optimum_batches(size_data, size_subset)
  size_batch_max <- optimum_subset(size_data, batches)
  if (size_subset >= size_batch_max && batches >= n_batch_max && size_subset*batches >= size_data) {
    return(TRUE)
  }
  FALSE
}

is_logical <- function(x){
  isTRUE(x) || isFALSE(x)
}

is_numeric <- function(x) {
  all(x > 0 & as.integer(x) == x & is.finite(x) & !is.na(x))
}

check_number <- function(x, name) {
  if (length(x) != 1 || !is_numeric(x) || x <= 1) {
    stop(sQuote(name, FALSE), " must be a single number bigger than 1.", call. = FALSE)
  }
}

mean_difference <- function(differences, subset_ind, eval_n) {
  # Calculate the score for each subset by variable
  apply(differences, 3, function(x, eval, indep) {
    x <- rbind(x, "independence" = 0)
    x <- insert(x, indep, name = "independence")
    colSums(x, na.rm = TRUE)/eval
  }, eval = eval_n, indep = subset_ind)
}

release_bullets <- function(){
  c("Update codemeta.json with: `codemetar::write_codemeta()`")
}


# Numbers are evaluated 4 times (mean, sd, mad, na),
# and categories only 3:  na, entropy, independence.
# check this on evaluate_index
evaluations <- function(num, eval_cat = 4, eval_num = 3) {
  eval_n <- ifelse(num, eval_cat, eval_num)
  # Add one more number for when multiple categories are present
  if (sum(!num) > 1) {
    eval_n <- c(eval_n, eval_cat)
  }
  eval_n
}



release_bullets <- function() {
  c("Run: cffr::cff_write()")
}
