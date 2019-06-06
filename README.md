
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

This is a basic example which shows you how to solve a common problem:

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
d <- design(metadata, 24)
# It is a list but we can convert it to a vector with:
batch_names(d)
#>  [1] "SubSet3" "SubSet1" "SubSet2" "SubSet1" "SubSet2" "SubSet1" "SubSet1"
#>  [8] "SubSet3" "SubSet2" "SubSet2" "SubSet3" "SubSet2" "SubSet2" "SubSet3"
#> [15] "SubSet3" "SubSet2" "SubSet1" "SubSet1" "SubSet3" "SubSet2" "SubSet1"
#> [22] "SubSet2" "SubSet1" "SubSet2" "SubSet3" "SubSet2" "SubSet1" "SubSet3"
#> [29] "SubSet1" "SubSet3" "SubSet2" "SubSet2" "SubSet3" "SubSet3" "SubSet3"
#> [36] "SubSet1" "SubSet1" "SubSet3" "SubSet2" "SubSet1" "SubSet1" "SubSet2"
#> [43] "SubSet1" "SubSet2" "SubSet1" "SubSet1" "SubSet3" "SubSet3" "SubSet2"
#> [50] "SubSet3"
```

Naively one would either fill some batches fully or distribute them not
evenly (the first 17 packages toghether, the next 17 and so on). This
solution ensures that the data is randomized.

If you need space for replicates to control for batch effect you can
use:

``` r
r <- replicates(metadata, 24, 5)
r
#> $SubSet1
#>  [1]  1  2  3  6  8  9 13 14 16 17 22 27 28 29 32 33 36 40 45 46 47 48
#> 
#> $SubSet2
#>  [1]  3  4  5  7  8  9 15 18 19 23 24 26 27 31 33 34 37 41 42 49
#> 
#> $SubSet3
#>  [1]  3  8  9 10 11 12 20 21 25 27 30 33 35 38 39 43 44 50
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
