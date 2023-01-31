#' Follow up experiments
#'
#' If an experiment was carried out with some samples and you want to continue
#' with some other samples later on.
#' @param original A `data.frame` with the information of the samples used originally.
#' @param follow_up A `data.frame` with the information of the new samples.
#' @param old_new Name of the column where the batch status will be stored. If
#' it matches the name of a column in original it will be used to find previous
#' batches.
#' @inheritParams design
#' @seealso [`follow_up2()`]
#' @return  A `data.frame` with the common columns of data, a new column
#' `old_new`, and a batch column filled with the new batches needed.
#' @export
#' @examples
#' data(survey, package = "MASS")
#' survey1 <- survey[1:118, ]
#' survey2 <- survey[119:nrow(survey), ]
#' fu <- follow_up(survey1, survey2, size_subset = 50, iterations = 10)
follow_up <- function(original, follow_up, size_subset, omit = NULL,
                      old_new = "batch", iterations = 500) {
  stopifnot(is.character(old_new) & length(old_new) == 1)
  stopifnot(is.null(omit) || is.character(omit))
  stopifnot(is.data.frame(original))
  stopifnot(!old_new %in% colnames(original), !old_new %in% colnames(follow_up))

  omit <- setdiff(omit, old_new)
  stopifnot(is.data.frame(follow_up))
  match_columns <- intersect(colnames(original), colnames(follow_up))
  mc <- setdiff(match_columns, omit)

  if (length(match_columns) == 0) {
    stop("No shared column between the two data.frames")
  }
  if (old_new %in% colnames(original)) {
    warning("There is already a follow up study, use follow_up2.", call. = FALSE)
  }

  original[[old_new]] <- "old"
  follow_up[[old_new]] <- "new"
  full <- rbind(original[, mc], follow_up[, mc])
  full_b <- rbind(original[, c(match_columns, old_new)],
                  follow_up[, c(match_columns, old_new)])

  .check_followup(full, full_b,
                  new_data = follow_up[, match_columns],
                  old_data = original[, match_columns])

  d <- .design(full_b, size_subset = size_subset, iterations = iterations, check = FALSE)
  inspect(d, full_b, omit = omit)
}

#' Follow up experiments in batches
#'
#' Design experiment with all the data new and old together.
#'
#' If the `batch_column` is empty the samples are considered new.
#' If the `size_subset` is missing, it will be estimated from the previous batch
#' Similarly, iterations and name will be guessed or inferred from the samples.
#' @param all_data A `data.frame` with all the data about the samples.
#' Each row is a sample.
#' @param batch_column The name of the column of `all_data` with the batches used.
#' If NA it is interpreted as a new data, if not empty it is considered a batch.
#' @inheritDotParams design -pheno
#' @seealso `follow_up()`
#' @return A `data.frame` with the `batch_column` filled with the new batches needed.
#' @export
#'
#' @examples
#' data(survey, package = "MASS")
#' # Create the first batch
#' first_batch_n <- 118
#' variables <- c("Sex", "Smoke", "Age")
#' survey1 <- survey[seq_len(first_batch_n), variables]
#' index1 <- design(survey1, size_subset = 50, iterations = 50)
#' r_survey <- inspect(index1, survey1)
#' # Create the second batch with "new" students
#' survey2 <- survey[seq(from = first_batch_n +1, to = nrow(survey)), variables]
#' survey2$batch <- NA
#' # Prepare the follow up
#' all_classroom <- rbind(r_survey, survey2)
#' follow_up2(all_classroom, size_subset = 50, iterations = 50)
follow_up2 <- function(all_data, batch_column = "batch", ...) {
  stopifnot(is.character(batch_column), length(batch_column) == 1)
  if (!anyNA(all_data[[batch_column]])) {
    stop("Seems that there is no new data: All the ", batch_column ," column is already filled up.")
  }

  new_data <- all_data[is.na(all_data[[batch_column]]), ]
  old_data <- all_data[!is.na(all_data[[batch_column]]), ]
  old_index <- use_index(old_data[[batch_column]])

  args <- list(...)

  if (!"size_subset" %in% names(args)) {
    args$size_subset <- max(lengths(old_index))
  }
  if (!"iterations" %in% names(args)) {
    #Set the same as the default for design
    args$iterations <- formals(design)$iterations
  }
  if (!"omit" %in% names(args)) {
    args$omit <- batch_column
    omit <- NULL
  } else {
    omit <- args$omit
    args$omit <- c(batch_column, args$omit)
  }
  if (!"name" %in% names(args)) {
    args$name <- "NewSubset"
  }
  all_data2 <- all_data
  all_data2[!is.na(all_data2[[batch_column]]), batch_column] <- "old"
  all_data2[is.na(all_data2[[batch_column]]), batch_column] <- "new"

  num <- is_num(all_data)
  n_unique <- sapply(all_data[, !num], function(x){length(unique(x))})
  which_s <- n_unique == nrow(all_data)
  if (sum(which_s) > 1) {
    warning("Multiple samples  were identified")
  }

  colnames <- colnames(all_data)
  .check_followup(all_data[, setdiff(colnames, args$omit)],
                  all_data2[, setdiff(colnames, omit)],
                  new_data[, setdiff(colnames, args$omit)],
                  old_data[, setdiff(colnames, args$omit)])

  new_index <- .design(new_data, size_subset = args$size_subset, omit = args$omit,
                       iterations = args$iterations, name = args$name, check = FALSE)

  w_new <- which(is.na(all_data[[batch_column]]))
  w_old <- which(!is.na(all_data[[batch_column]]))
  position_old_new <- c(w_old, w_new)
  batches <- c(old_data[[batch_column]], batch_names(new_index))
  batches[position_old_new]
}

#' Check the data for a follow up experiment.
#'
#' Sometimes some samples are collected and analyzed, later another batch of
#' samples is analyzed.
#' This function tries to detect if there are problems with the data or when
#'  the data is combined in a single analysis.
#' To know specific problems with the data you need to use check_data()
#' @param column The name of the column where the old data has the batch
#' information, or whether the data is new or not (`NA`) in the case of all_data.
#' @param old_data,new_data A data.frame with the old and new data respectively.
#' @inheritParams follow_up
#' @inheritParams follow_up2
#' @seealso `check_data()`
#' @export
#' @return Called by its side effects of warnings, but returns a logical value
#' if there are some issues (FALSE) or not (TRUE)
#' @examples
#' data(survey, package = "MASS")
#' survey1 <- survey[1:118, ]
#' survey2 <- survey[119:nrow(survey), ]
#' valid_followup(survey1, survey2)
#' survey$batch <- NA
#' survey$batch[1:118]  <- "old"
#' valid_followup(all_data = survey)
valid_followup <- function(old_data = NULL, new_data = NULL, all_data = NULL,
                           omit = NULL, column = "batch") {
  valid_column <- !is.null(column) && length(column) == 1

  if (!is.null(old_data) && !is.null(new_data) && valid_column) {
    omit <- setdiff(omit, column)
    stopifnot(is.data.frame(new_data))
    stopifnot(is.data.frame(old_data))
    match_columns <- intersect(colnames(old_data), colnames(new_data))
    mc <- setdiff(match_columns, omit)

    if (length(match_columns) == 0) {
      stop("No shared column between the two data.frames")
    }
    if (column %in% colnames(old_data)) {
      warning("There is already a follow up study, use follow_up2.", call. = FALSE)
    }


    all_data <- rbind(old_data[, mc], new_data[, mc])
    all_data2 <- rbind(old_data[, mc], new_data[, mc])
    all_data2[[column]] <- c(rep("old", nrow(old_data)),
                             rep("new", nrow(new_data)))
  } else if (!is.null(all_data) && valid_column) {
    all_data <- all_data[, setdiff(colnames(all_data), omit)]
    all_data2 <- all_data
    all_data2[!is.na(all_data2[[column]]), column] <- "old"
    all_data2[is.na(all_data2[[column]]), column] <- "new"
    new_data <- all_data[is.na(all_data2[[column]]), ]
    old_data <- all_data[!is.na(all_data2[[column]]), ]
  } else {
    stop("Unexpected input", call. = FALSE)
  }

  .check_followup(all_data, all_data2, new_data, old_data)
}

.check_followup <- function(all_data, all_data2, new_data, old_data, verbose = TRUE) {

  # Check all data but omitting batch name
  check_all <- .check_data(all_data, verbose = FALSE)
  # Check all data but knowing that there is an old and new category
  check_cmbn <- .check_data(all_data2, verbose = FALSE)
  # Check data
  check_new <- .check_data(new_data, verbose = FALSE)
  check_old <- .check_data(old_data, verbose = FALSE)
  ok <- TRUE
  if (!check_all) {
    if (verbose){
      warning("There are some problems with the data.", call. = FALSE)
    }
    ok <- FALSE
  }
  if (check_all && !check_cmbn) {
    if (verbose) {
      warning("There are some problems with the addition of the new samples.",
              call. = FALSE)
    }
    ok <- FALSE
  }
  if (!check_cmbn) {
    if (verbose) {
      warning("There are some problems with the new samples and the batches.",
              call. = FALSE)
    }
    ok <- FALSE
  }
  if (!check_new) {
    if (verbose ) {
      warning("There are some problems with the new data.", call. = FALSE)
    }
    ok <- FALSE
  }
  if (!check_old) {
    if (verbose) {
      warning("There are some problems with the old data.", call. = FALSE)
    }
    ok <- FALSE
  }

  ok
}
