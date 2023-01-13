#' Follow up experiments
#'
#' If an experiment was carried out with some samples and you want to continue
#' with some other samples later on.
#' @param original A `data.frame` with the information of the samples used originally.
#' @param follow_up A `data.frame` with the information of the new samples.
#' @param old_new Name of the column where the batch status will be stored. If
#' it matches the name of a column in original it will be used to find previous
#' batches.
#' @seealso follow_up2()
#' @return
#' @export
#'
#' @examples
follow_up <- function(original, follow_up, old_new = "batch") {
  stopifnot(is.character(old_new))
  if (!.check_data(original)) {
    warning("There might be some problems with the original data use check_data().")
  }

  stopifnot(!is.data.frame(follow_up))
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
    stop("Seems that there is no new data: All the ", old_new ," column is already filled up.")
  }

  check_data(all_data[, setdiff(colnames(all_data), batch_column)])
  num <- is_num(all_data)
  n_unique <- sapply(all_data[, !num], function(x){length(unique(x))})
  which_s <- n_unique == nrow(all_data)
  if (sum(which_s) > 1) {
    warning("Multiple samples were identified")
  }

  new_data <- all_data[is.na(all_data[[batch_column]]), ]
  old_data <- all_data[!is.na(all_data[[batch_column]]), ]
  old_index <- use_index(old_data[[batch_column]])
  # FIXME
  all_data2 <- all_data
  all_data2[!is.na(all_data2[[batch_column]])] <- "old"
  all_data2[is.na(all_data2[[batch_column]])] <- "new"

  if (missing(size_subset)) {
    size_subset <- max(lengths(old_index))
  }
  if (missing(iterations)) {
    iterations <- 500
  }
  if (missing(omit)) {
    omit <- batch_column
  } else {
    omit <- c(batch_column, omit)
  }
  if (missing(name)) {
    name <- "NewSubset"
  }

  check_index(all_data, use_index(all_data2[[batch_column]]))


  new_index <- design(new_data, size_subset = size_subset, omit = omit,
         iterations = iterations, name = name)

  new_index
}

check_followup <- function(all_data, old_new = "batch") {

}
