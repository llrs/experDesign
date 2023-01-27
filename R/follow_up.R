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
#' @seealso follow_up2()
#' @return
#' @export
#' @examples
#' data(survey, package = "MASS")
#' survey1 <- survey[1:118, ]
#' survey2 <- survey[119:nrow(survey), ]
#' fu <- follow_up(survey1, survey2, iterations = 10)
follow_up <- function(original, follow_up, old_new = "batch", iterations = 500) {
  stopifnot(is.character(old_new) & length(old_new) == 1)
  stopifnot(is.data.frame(original))
  if (!.check_data(original)) {
    warning("There might be some problems with the original data use check_data().")
  }

  stopifnot(is.data.frame(follow_up))
  match_columns <- intersect(colnames(original), colnames(follow_up))

  if (length(match_columns) == 0) {
    stop("No shared column between the two data.frames")
  }
  if (old_new %in% colnames(original)) {
    warning("There is already a follow up study, use follow_up2.")
  }

  original[[old_new]] <- "old"
  follow_up[[old_new]] <- "new"



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
  # Check all data but omitting batch name
  check_all <- .check_data(all_data[, setdiff(colnames, args$omit)],
                             verbose = FALSE)
  # Check all data but knowing that there is an old an new category
  check_cmbn <- .check_data(all_data2[, setdiff(colnames, omit)],
                            verbose = FALSE)
  # Check new data
  check_new <- .check_data(new_data[, setdiff(colnames, args$omit)],
                           verbose = FALSE)
  if (!check_all) {
    warning("There are some problems with the data.", call. = FALSE)
  }
  if (check_all && !check_cmbn) {
    warning("There are some problems with the addition of the new samples.",
            call. = FALSE)
  }
  if (!check_cmbn) {
    warning("There are some problems with the new samples and the batches.",
            call. = FALSE)
  }
  if (!check_new) {
    warning("There are some problems with the new data.", call. = FALSE)
  }

  new_index <- .design(new_data, size_subset = args$size_subset, omit = args$omit,
         iterations = args$iterations, name = args$name, check = FALSE)

  w_new <- which(is.na(all_data[[batch_column]]))
  w_old <- which(!is.na(all_data[[batch_column]]))
  position_old_new <- c(w_old, w_new)
  batches <- c(old_data[[batch_column]], batch_names(new_index))
  batches[position_old_new]
}

check_followup <- function(all_data, old_new = "batch") {

}
