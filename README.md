
<!-- README.md is generated from README.Rmd. Please edit that file -->

# experDesign

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/experDesign)](https://CRAN.R-project.org/package=experDesign)
[![R build
status](https://github.com/llrs/experDesign/workflows/R-CMD-check/badge.svg)](https://github.com/llrs/experDesign/actions?workflow=R-CMD-check)
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
#>  [1]   1   2   4   6  11  18  22  25  38  40  44  46  48  50  55  60  63  67  70
#> [20]  85  91  92  99 100 103 105 110 116 120 126 129 134 141 144 145 149 160 165
#> [39] 168 171 172 174 178 185 190 196 197 198 201 204 206 208 209 210 213 216 218
#> [58] 228 231 232
#> 
#> $SubSet2
#>  [1]   7   9  12  13  15  17  23  30  43  47  49  58  62  64  66  69  71  73  76
#> [20]  79  80  81  88  90  98 102 108 109 114 115 118 121 123 124 125 128 131 132
#> [39] 139 146 148 151 153 155 159 164 169 175 177 181 182 183 194 211 217 222 225
#> [58] 227 233
#> 
#> $SubSet3
#>  [1]   5   8  14  16  19  20  24  26  27  28  29  34  35  37  41  42  51  53  61
#> [20]  72  74  75  78  83  87  89  95  96 104 107 113 117 119 122 133 140 143 150
#> [39] 152 154 156 157 161 166 179 184 186 187 188 191 193 195 202 207 214 224 226
#> [58] 230 237
#> 
#> $SubSet4
#>  [1]   3  10  21  31  32  33  36  39  45  52  54  56  57  59  65  68  77  82  84
#> [20]  86  93  94  97 101 106 111 112 127 130 135 136 137 138 142 147 158 162 163
#> [39] 167 170 173 176 180 189 192 199 200 203 205 212 215 219 220 221 223 229 234
#> [58] 235 236
```

We can transform then into a vector to append to the file or to pass to
the lab mate with:

``` r
head(batch_names(index))
#> [1] "SubSet1" "SubSet1" "SubSet4" "SubSet1" "SubSet3" "SubSet1"
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
