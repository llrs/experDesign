
<!-- README.md is generated from README.Rmd. Please edit that file -->

# experDesign

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/llrs/experDesign.svg?branch=master)](https://travis-ci.org/llrs/experDesign)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/llrs/experDesign?branch=master&svg=true)](https://ci.appveyor.com/project/llrs/experDesign)
[![Coverage
status](https://codecov.io/gh/llrs/experDesign/branch/master/graph/badge.svg)](https://codecov.io/github/llrs/experDesign?branch=master)
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Project Status: Active - The project has reached a stable, usable
state and is being actively
developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![R build
status](https://github.com/llrs/experDesign/workflows/R-CMD-check/badge.svg)](https://github.com/llrs/experDesign/actions?workflow=R-CMD-check)
<!-- badges: end -->

The goal of experDesign is to help you decide which samples go in which
batch, reducing the potential batch bias when analyzing.

## Installation

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
most.):

``` r
d <- design(metadata, 24)
# It is a list but we can convert it to a vector with:
batch_names(d)
#>  [1] "SubSet1" "SubSet3" "SubSet2" "SubSet3" "SubSet1" "SubSet1" "SubSet2"
#>  [8] "SubSet1" "SubSet3" "SubSet2" "SubSet2" "SubSet1" "SubSet2" "SubSet2"
#> [15] "SubSet3" "SubSet2" "SubSet3" "SubSet1" "SubSet3" "SubSet1" "SubSet2"
#> [22] "SubSet2" "SubSet1" "SubSet2" "SubSet1" "SubSet2" "SubSet3" "SubSet2"
#> [29] "SubSet3" "SubSet1" "SubSet2" "SubSet1" "SubSet3" "SubSet1" "SubSet2"
#> [36] "SubSet3" "SubSet2" "SubSet1" "SubSet3" "SubSet1" "SubSet1" "SubSet3"
#> [43] "SubSet2" "SubSet1" "SubSet3" "SubSet3" "SubSet3" "SubSet3" "SubSet1"
#> [50] "SubSet2"
```

Naively one would either fill some batches fully or distribute them not
evenly (the first 17 packages together, the next 17 and so on). This
solution ensures that the data is randomized.

If you need space for replicates to control for batch effect you can
use:

``` r
r <- replicates(metadata, 24, 5)
r
#> $SubSet1
#>  [1]  2  8 10 15 19 20 21 24 26 27 31 33 37 40 42 43 45 46 48
#> 
#> $SubSet2
#>  [1]  1  3  5  7  9 11 16 18 20 23 29 34 36 38 41 42 43 45 46 49 50
#> 
#> $SubSet3
#>  [1]  4  6 12 13 14 17 20 22 25 28 30 32 35 39 42 43 44 45 46 47
```

Which seeks as controls the most diverse values and adds them to the
samples distribution.

# Previous work

The [OSAT](https://bioconductor.org/packages/OSAT/) package handles
categorical variables but not numeric data. It doesn’t work with our
data.

The [minDiff](https://github.com/m-Py/minDiff) package reported in
[Stats.SE](https://stats.stackexchange.com/a/326015/105234), handles
both numeric and categorical data. But it can only optimize for two
nominal criteria. It doesn’t work for our data.

The [DeclareDesign](https://github.com/DeclareDesign/DeclareDesign) or
[OSAT](http://bioconductor.org/packages/OSAT) packages are also relevant

Question in
[Bioinformatics.SE](https://bioinformatics.stackexchange.com/q/4765/48)

# Other

Please note that this project is released with a [Contributor Code of
Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree
to abide by its terms.
