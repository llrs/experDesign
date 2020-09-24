
<!-- README.md is generated from README.Rmd. Please edit that file -->

# experDesign

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/llrs/experDesign.svg?branch=master)](https://travis-ci.org/llrs/experDesign)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/llrs/experDesign?branch=master&svg=true)](https://ci.appveyor.com/project/llrs/experDesign)
[![Coverage
status](https://codecov.io/gh/llrs/experDesign/branch/master/graph/badge.svg)](https://codecov.io/github/llrs/experDesign?branch=master)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable)
[![Project Status: Active - The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![R build
status](https://github.com/llrs/experDesign/workflows/R-CMD-check/badge.svg)](https://github.com/llrs/experDesign/actions?workflow=R-CMD-check)
<!-- badges: end -->

The goal of experDesign is to help you decide which samples go in which
batch, reducing the potential batch bias when analyzing.

## Installation

To install the latest version on
[CRAN](https://CRAN.R-project.org/package=experDesign) use:

``` r
install.packages("experDesign")
```

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("llrs/experDesign")
```

## Example

Imagine you have some samples already collected and you want to
distributed them in batches:

``` r
library("experDesign")
metadata <- expand.grid(height = seq(60, 80, 5), 
                        weight = seq(100, 300, 50),
                        sex = c("Male","Female"))
head(metadata, 15)
#>    height weight  sex
#> 1      60    100 Male
#> 2      65    100 Male
#> 3      70    100 Male
#> 4      75    100 Male
#> 5      80    100 Male
#> 6      60    150 Male
#> 7      65    150 Male
#> 8      70    150 Male
#> 9      75    150 Male
#> 10     80    150 Male
#> 11     60    200 Male
#> 12     65    200 Male
#> 13     70    200 Male
#> 14     75    200 Male
#> 15     80    200 Male
```

If you block incorrectly and end up with a group in a single batch we
will end up with batch effect. In order to avoid this `design` helps you
assign each sample to a batch (in this case each batch has 24 samples at
most). First we can explore the number of samples and the number of
batches:

``` r
size_data <- nrow(metadata)
size_batch <- 24
(batches <- optimum_batches(size_data, size_batch))
#> [1] 3
# So now the best number of samples for each batch is less than the available
(size <- optimum_subset(size_data, batches))
#> [1] 17
# The distribution of samples per batch
sizes_batches(size_data, size, batches)
#> [1] 17 17 16
```

Note that instead of using a whole batch and then leave a single sample
on the third distributes all the samples in the three batches that will
be needed. We can directly look for the distribution of the samples
given our max number of samples per batch:

``` r
d <- design(metadata, size_batch)
# It is a list but we can convert it to a vector with:
batch_names(d)
<<<<<<< HEAD
#>  [1] "SubSet2" "SubSet3" "SubSet1" "SubSet1" "SubSet2" "SubSet1" "SubSet2"
#>  [8] "SubSet2" "SubSet1" "SubSet3" "SubSet2" "SubSet2" "SubSet3" "SubSet2"
#> [15] "SubSet3" "SubSet1" "SubSet1" "SubSet3" "SubSet3" "SubSet2" "SubSet2"
#> [22] "SubSet2" "SubSet3" "SubSet3" "SubSet2" "SubSet1" "SubSet3" "SubSet2"
#> [29] "SubSet2" "SubSet3" "SubSet3" "SubSet3" "SubSet1" "SubSet3" "SubSet1"
#> [36] "SubSet1" "SubSet2" "SubSet2" "SubSet1" "SubSet1" "SubSet3" "SubSet1"
#> [43] "SubSet3" "SubSet2" "SubSet1" "SubSet1" "SubSet1" "SubSet2" "SubSet1"
=======
#>  [1] "SubSet3" "SubSet3" "SubSet1" "SubSet1" "SubSet2" "SubSet3" "SubSet1"
#>  [8] "SubSet3" "SubSet2" "SubSet2" "SubSet2" "SubSet2" "SubSet3" "SubSet1"
#> [15] "SubSet3" "SubSet2" "SubSet3" "SubSet3" "SubSet2" "SubSet1" "SubSet1"
#> [22] "SubSet1" "SubSet2" "SubSet3" "SubSet1" "SubSet1" "SubSet3" "SubSet2"
#> [29] "SubSet2" "SubSet1" "SubSet2" "SubSet2" "SubSet1" "SubSet3" "SubSet2"
#> [36] "SubSet1" "SubSet3" "SubSet3" "SubSet1" "SubSet1" "SubSet1" "SubSet1"
#> [43] "SubSet2" "SubSet2" "SubSet3" "SubSet2" "SubSet3" "SubSet2" "SubSet1"
>>>>>>> b71fbd71a3929eb18f9383814daa8ad09706920e
#> [50] "SubSet3"
```

Naively one would either fill some batches fully or distribute them not
evenly (the first 17 packages together, the next 17 and so on). This
solution ensures that the data is randomized. For more random
distribution you can increase the number of iterations performed to
calculate this distribution.

If you need space for replicates to control for batch effect you can
use:

``` r
r <- replicates(metadata, size_batch, 5)
lengths(r)
#> SubSet1 SubSet2 SubSet3 
<<<<<<< HEAD
#>      22      21      17
r
#> $SubSet1
#>  [1]  1  3  6 14 16 17 19 21 23 25 26 27 31 34 40 41 42 43 45 48 49 50
#> 
#> $SubSet2
#>  [1]  4  5 10 11 13 15 18 21 23 24 28 32 35 37 38 41 44 45 46 47 50
#> 
#> $SubSet3
#>  [1]  2  7  8  9 12 20 21 22 23 29 30 33 36 39 41 45 50
=======
#>      21      20      19
r
#> $SubSet1
#>  [1]  4  5  9 11 12 14 15 17 20 23 26 29 32 33 34 37 38 45 46 48 49
#> 
#> $SubSet2
#>  [1]  2  6  8  9 13 14 15 19 22 24 25 27 30 34 35 36 37 41 42 44
#> 
#> $SubSet3
#>  [1]  1  3  7  9 10 14 15 16 18 21 28 31 34 37 39 40 43 47 50
>>>>>>> b71fbd71a3929eb18f9383814daa8ad09706920e
```

Which seeks as controls the most diverse values and adds them to the
samples distribution. Note that if the sample is already present on that
batch is not added again, that’s why the number of samples per batch is
different from the design without replicates.

# Previous work

The CRAN task View of [Experimental
Design](https://CRAN.R-project.org/view=ExperimentalDesign) includes
many packages relevant for designing an experiment before collecting
data, but none of them provides how to manage them once the samples are
already collected.

Two packages allow to distribute the samples on batches:

  - The [OSAT](https://bioconductor.org/packages/OSAT/) package handles
    categorical variables but not numeric data. It doesn’t work with our
    data.

  - The [minDiff](https://github.com/m-Py/minDiff) package reported in
    [Stats.SE](https://stats.stackexchange.com/a/326015/105234), handles
    both numeric and categorical data. But it can only optimize for two
    nominal criteria. It doesn’t work for our data.

If you are still designing the experiment and do not have collected any
data [DeclareDesign](https://cran.r-project.org/package=DeclareDesign)
might be relevant for you.

Question in
[Bioinformatics.SE](https://bioinformatics.stackexchange.com/q/4765/48)
I made before developing the package.

# Other

Please note that this project is released with a [Contributor Code of
Conduct](https://llrs.github.io/experDesign/CODE_OF_CONDUCT.html). By
participating in this project you agree to abide by its terms.
