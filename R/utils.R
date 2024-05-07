# Colum type helpers ####
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

# Other ####

omit <- function(pheno, omit){
  # Omit columns
  if (!is.null(omit)) {
    col_diff <- setdiff(omit, colnames(pheno))
    if (length(col_diff) != 0L) {
      warning("Columns to omit were not present: ",
              paste(col_diff, collapse = ", "), ".")
    }
    pheno[, !colnames(pheno) %in% omit, drop = FALSE]
  } else {
    pheno
  }
}

# By default assumes that the index is applied as is to a data.frame that is
# expanded based on the index
translate_index <- function(index,
                            new_position = seq_len(sum(lengths(index))),
                            old_position = NULL) {
  if (is.null(old_position)) {
    old_position <- unlist(index, FALSE, FALSE)
  }
  stopifnot(length(new_position) == length(old_position))
  stopifnot(sum(lengths(index)) == length(new_position))

  old_position <- sort(old_position)
  # Used because unlist is not documented to keep order
  for (i in seq_along(index)) {
    m <- match(index[[i]], old_position)

    # Remove positions already matched because match returns the first value
    old_position <- old_position[-m]
    index[[i]] <- new_position[m]
    new_position <- new_position[-m]
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

release_bullets <- function() {
  c("Update codemeta.json with: `codemetar::write_codemeta()`",
    "Run: cffr::cff_write()")
}

# Numbers are evaluated 4 times: mean, sd, mad, na.
# categories  evaluated 3 times:  na, entropy, independence.
# check this on evaluate_index
evaluations <- function(num, eval_cat = 4, eval_num = 3) {
  eval_n <- ifelse(num, eval_cat, eval_num)
  # Add one more number for when multiple categories are present
  if (sum(!num) > 1) {
    eval_n <- c(eval_n, eval_cat)
  }
  eval_n
}

add_column <- function(x, values, name) {
  # Add the column and rename it
  if (name %in% colnames(x)) {
    msg <- paste("Column", name, "is already present. Did you meant this?")
    warning(msg, call. = FALSE)
  }
  out <- cbind(x, values)
  colnames(out)[ncol(out)] <- name
  rownames(out) <- NULL
  out
}


consistent_index <- function(i, pheno) {
  ui <- unlist(i, FALSE, FALSE)
  not_matching <- sum(lengths(i)) != NROW(pheno)
  index_longer <- sum(lengths(i)) > NROW(pheno)
  no_replicate <- !any(table(ui) > 1)
  bigger_position <- max(ui, na.rm = TRUE) > NROW(pheno)

  if (bigger_position) {
    stop("The index has positions that are higher than the number of rows in the data.", call. = FALSE)
  }

  if (not_matching && index_longer && no_replicate) {
    stop("Index is longer than the data and there is no replicate.", call. = FALSE)
  }

  index_shorter <- sum(lengths(i)) < NROW(pheno)
  if (not_matching && index_shorter) {
    stop("Index is shorter than the data provided.", call. = FALSE)
  }
  TRUE
}