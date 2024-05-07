check_block <- function(pheno, batches) {
  out <- TRUE
  num <- is_num(pheno)
  cols <- colnames(pheno)
  if (batches <= 1) {
    stop("Only one batch!", call. = FALSE)
    return(FALSE)
  }
  if (any(num)) {
    stop("Provided a blocking variable that is numeric: ",
         paste(cols[num], collapse = ","), ".\n\t",
         "Consider converting it to character or ",
         "do not block by numeric variables", call. = FALSE)
  }


  divisible <- vapply(pheno, function(x){
    length(unique(x)) %% batches == 0
  }, logical(1L))
  if (any(!divisible)) {
    cols <- names(divisible)[!divisible]
    warning("These variables cannot be blocked: ",
            paste(cols, collapse = ", "),
            "\nWill attempt the best in the order given.", call. = FALSE)
    out <- FALSE
  }

  full_combination <- apply(pheno, 1, paste0, collapse = "")
  full_divisible <- length(unique(full_combination)) %% batches == 0

  if (any(!full_divisible)) {
    warning("All factors combined are not divisible into blocks.", call. = FALSE)
    out <- FALSE
  }
  out
}

# TODO Create sombe batches with the blocked variables split between them:
block <- function(pheno, batches) {

  for (col in colnames(pheno)) {
    sa <- seq_along(pheno[[col]])
    s <- split(sa, pheno[[col]])
    size <- length(unique(pheno[[col]]))
    l <- lapply(s, split, f = rep(seq_len(size),
                                  lengt.out = batches*size))
    match(u, )

  }
}