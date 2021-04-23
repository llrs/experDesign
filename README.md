
<!-- README.md is generated from README.Rmd. Please edit that file -->

# experDesign

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/experDesign)](https://CRAN.R-project.org/package=experDesign)
[![R build
status](https://github.com/llrs/experDesign/workflows/R-CMD-check/badge.svg)](https://github.com/llrs/experDesign/actions?workflow=R-CMD-check)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/llrs/experDesign?branch=master&svg=true)](https://ci.appveyor.com/project/llrs/experDesign)
[![Travis build
status](https://travis-ci.org/llrs/experDesign.svg?branch=master)](https://travis-ci.org/llrs/experDesign)
[![Coverage
status](https://codecov.io/gh/llrs/experDesign/branch/master/graph/badge.svg)](https://codecov.io/github/llrs/experDesign?branch=master)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![Project Status: Active - The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
<!-- badges: end -->

The goal of experDesign is to help you decide which samples go in which
batch, reducing the potential batch bias before performing an
experiment. It provides three main functions :

-   `design()`: Randomize the samples according to their variables.
-   `replicates()`: Selects some samples for replicates and randomizes
    the samples.
-   `spatial()`: Randomize the samples on a spatial grid.

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

We can use the survey dataset for the examples:

``` r
library("experDesign")
data(survey, package = "MASS") 
head(survey)
#>      Sex Wr.Hnd NW.Hnd W.Hnd    Fold Pulse    Clap Exer Smoke Height      M.I
#> 1 Female   18.5   18.0 Right  R on L    92    Left Some Never 173.00   Metric
#> 2   Male   19.5   20.5  Left  R on L   104    Left None Regul 177.80 Imperial
#> 3   Male   18.0   13.3 Right  L on R    87 Neither None Occas     NA     <NA>
#> 4   Male   18.8   18.9 Right  R on L    NA Neither None Never 160.00   Metric
#> 5   Male   20.0   20.0 Right Neither    35   Right Some Never 165.00   Metric
#> 6 Female   18.0   17.7 Right  L on R    64   Right Some Never 172.72 Imperial
#>      Age
#> 1 18.250
#> 2 17.583
#> 3 16.917
#> 4 20.333
#> 5 23.667
#> 6 21.000
```

The dataset has numeric, categorical values and some `NA`’s value.

# Picking samples for each batch

Imagine that we can only work in groups of 70, and we want to randomize
by Sex, Smoke, Age, and by writing hand.  
There are 1.6543999^{61} combinations some of them would be have in a
single experiment all the right handed students. We could measure all
these combinations but we can try to find an optimum value.

``` r
# To reduce the variables used:
omit <- c("Wr.Hnd", "NW.Hnd", "Fold", "Pulse", "Clap", "Exer", "Height", "M.I")
(keep <- colnames(survey)[!colnames(survey) %in% omit])
#> [1] "Sex"   "W.Hnd" "Smoke" "Age"
head(survey[, keep])
#>      Sex W.Hnd Smoke    Age
#> 1 Female Right Never 18.250
#> 2   Male  Left Regul 17.583
#> 3   Male Right Occas 16.917
#> 4   Male Right Never 20.333
#> 5   Male Right Never 23.667
#> 6 Female Right Never 21.000

# Looking for groups at most of 70 samples.
index <- design(pheno = survey, size_subset = 70, omit = omit)
index
#> $SubSet1
#>  [1]  14  16  29  30  33  37  39  49  51  52  57  68  72  73  74  76  77  78  82
#> [20]  92  93 107 108 109 111 118 122 123 124 125 129 137 140 142 151 152 158 160
#> [39] 162 164 165 168 170 181 182 183 184 191 193 195 214 218 221 222 223 224 228
#> [58] 234 235 237
#> 
#> $SubSet2
#>  [1]   2   3   4  12  13  15  25  27  32  43  44  50  53  54  63  65  66  71  79
#> [20]  83  84  85  86 101 102 106 116 121 131 135 136 138 139 144 147 149 153 157
#> [39] 161 163 167 171 175 180 188 192 194 204 209 211 212 213 215 216 219 225 226
#> [58] 227 229
#> 
#> $SubSet3
#>  [1]   1   5   7   8  11  17  20  21  22  23  24  31  34  38  40  41  45  48  55
#> [20]  56  60  62  64  67  87  90  94 100 104 105 110 112 113 114 115 117 119 120
#> [39] 126 128 145 155 156 159 166 169 172 178 179 185 187 196 199 200 202 203 210
#> [58] 220 230
#> 
#> $SubSet4
#>  [1]   6   9  10  18  19  26  28  35  36  42  46  47  58  59  61  69  70  75  80
#> [20]  81  88  89  91  95  96  97  98  99 103 127 130 132 133 134 141 143 146 148
#> [39] 150 154 173 174 176 177 186 189 190 197 198 201 205 206 207 208 217 231 232
#> [58] 233 236
```

We can transform then into a vector to append to the file or to pass to
the lab mate with:

``` r
head(batch_names(index))
#> [1] "SubSet3" "SubSet2" "SubSet2" "SubSet2" "SubSet3" "SubSet4"
```

# Previous work

The CRAN task View of [Experimental
Design](https://CRAN.R-project.org/view=ExperimentalDesign) includes
many packages relevant for designing an experiment before collecting
data, but none of them provides how to manage them once the samples are
already collected.

Two packages allow to distribute the samples on batches:

-   The
    [OSAT](https://bioconductor.org/packages/release/bioc/html/OSAT.html)
    package handles categorical variables but not numeric data. It
    doesn’t work with our data.

-   The [minDiff](https://github.com/m-Py/minDiff) package reported in
    [Stats.SE](https://stats.stackexchange.com/a/326015/105234), handles
    both numeric and categorical data. But it can only optimize for two
    nominal criteria. It doesn’t work for our data.

-   The [Omixer](https://bioconductor.org/packages/Omixer/) package
    handles both numeric and categorical data (converting categorical
    variables to numeric). But both the same way either Pearson’s
    Chi-squared Test if there are few samples or Kendall’s correlation.
    It does allow to protect some spots from being used.

If you are still designing the experiment and do not have collected any
data [DeclareDesign](https://cran.r-project.org/package=DeclareDesign)
might be relevant for you.

Question in
[Bioinformatics.SE](https://bioinformatics.stackexchange.com/q/4765/48)
I made before developing the package.

# Other

Please note that this project is released with a [Contributor Code of
Conduct](https://www.contributor-covenant.org/version/1/0/0/code-of-conduct/).
By participating in this project you agree to abide by its terms.
