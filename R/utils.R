is_num <- function(x, ...) {
  if (is.null(ncol(x))) {
    is.numeric(x)
  } else if (ncol(x) == 1) {
    apply(x, 2, is.numeric)
  } else {
    vapply(x, is.numeric, logical(1L))
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

  for (i in seq_along(index)) {
    index[[i]] <- old_position[new_position %in% index[[i]]]
  }
  index
}


position_name <- function(rows, columns) {
  nrow <- length(rows)
  ncol <- length(columns)
  plate <- matrix(nrow = nrow, ncol = ncol, dimnames = list(rows, columns))
  positions <- expand.grid(rows, columns, stringsAsFactors = FALSE)
  positions$Var2 <- as.character(positions$Var2)
  positions$name <- apply(positions, 1, paste0, collapse = "")
  colnames(positions)[1:2] <- c("row", "column")
  positions
}

summary_num <- function(pheno) {
  if (is.null(ncol(pheno))) {
    ncol <- 1
    column <- "variable"
  } else {
    ncol <- ncol(pheno)
    column <- colnames(pheno)
  }
  diff <- matrix(0, ncol = ncol, nrow = 5)
  rownames(diff) <- c("mean", "sd", "mad", "na", "entropy")
  colnames(diff) <- column
  diff
}

check_sizes <- function(size_data, n_batch, size_batch){
  size_batch_min <- ceiling(size_data/n_batch)
  n_batch_max <- ceiling(size_data/size_batch)
  if (size_batch >= size_batch_min && n_batch >= n_batch_max) {
    return(TRUE)
  }
  FALSE
}



mean_difference <- function(differences, subset_ind, eval_n) {
  # Calculate the score for each subset by variable
  apply(differences, 3, function(x) {
    x <- rbind(x, "ind" = 0)
    x <- insert(x, subset_ind, name = "ind")
    colSums(x, na.rm = TRUE)/eval_n
  })
}
