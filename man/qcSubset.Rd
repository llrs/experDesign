% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/QC.R
\name{qcSubset}
\alias{qcSubset}
\title{Random subset}
\usage{
qcSubset(index, size, each = FALSE)
}
\arguments{
\item{index}{A list of indices indicating which samples go to which subset.}

\item{size}{The number of samples that should be taken.}

\item{each}{A logical value if the subset should be taken from all the
samples or for each batch.}
}
\description{
Select randomly some samples from an index
}
\examples{
set.seed(50)
index <- create_subset(100, 50, 2)
QC_samples <- qcSubset(index, 10)
QC_samplesBatch <- qcSubset(index, 10, TRUE)
}
