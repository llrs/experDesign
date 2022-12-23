
<!-- README.md is generated from README.Rmd. Please edit that file -->

# experDesign

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/experDesign)](https://CRAN.R-project.org/package=experDesign)
[![R-CMD-check](https://github.com/llrs/experDesign/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/llrs/experDesign/actions/workflows/R-CMD-check.yaml)
[![Coverage
status](https://codecov.io/gh/llrs/experDesign/branch/master/graph/badge.svg)](https://codecov.io/github/llrs/experDesign?branch=master)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![Project Status: Active - The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![JOSS](https://joss.theoj.org/papers/10.21105/joss.03358/status.svg)](https://doi.org/10.21105/joss.03358)
[![DOI](https://zenodo.org/badge/142569201.svg)](https://zenodo.org/badge/latestdoi/142569201)

<!-- badges: end -->

The goal of experDesign is to help you decide which samples go in which
batch, reducing the potential batch bias before performing an
experiment. It provides three main functions :

- `check_data()`: Check if there are any problems with the data.
- `design()`: Randomize the samples according to their variables.
- `replicates()`: Selects some samples for replicates and randomizes the
  samples.
- `spatial()`: Randomize the samples on a spatial grid.

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

We can check some issues from an experimental point of view via
`check_data()`:

``` r
check_data(survey)
#> Warning: Some values are missing.
#> Warning: There is a combination of categories with no replicates; i.e. just one
#> sample.
#> [1] FALSE
```

As you can see with the warnings we get a collections of problems. In
general, try to have at least 3 replicates for each condition and try to
have all the data of each variable.

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
#> Warning: There might be some problems with the data use check_data().
index
#> $SubSet1
#>  [1]   1   7  13  22  23  25  28  29  33  40  46  47  51  52  54  60  73  74  80
#> [20]  84  95 108 109 116 123 129 131 132 134 136 140 141 150 151 159 161 163 164
#> [39] 171 175 178 180 181 182 186 187 190 197 199 200 205 207 209 210 215 216 224
#> [58] 226 227 235
#> 
#> $SubSet2
#>  [1]   4   5  14  26  27  30  31  32  37  39  41  44  48  55  59  61  62  66  68
#> [20]  71  72  75  81  86  90  94  96 100 102 103 106 107 110 113 115 117 125 137
#> [39] 144 145 148 152 156 158 167 168 169 170 177 183 193 198 202 206 213 217 218
#> [58] 223 232
#> 
#> $SubSet3
#>  [1]   2   3   9  10  12  16  17  19  20  34  38  45  49  50  53  63  64  67  69
#> [20]  76  79  87  88  89  93  97  98 101 104 105 111 112 119 120 124 130 133 138
#> [39] 143 146 154 160 162 165 184 185 188 192 203 204 211 214 219 221 230 231 233
#> [58] 234 237
#> 
#> $SubSet4
#>  [1]   6   8  11  15  18  21  24  35  36  42  43  56  57  58  65  70  77  78  82
#> [20]  83  85  91  92  99 114 118 121 122 126 127 128 135 139 142 147 149 153 155
#> [39] 157 166 172 173 174 176 179 189 191 194 195 196 201 208 212 220 222 225 228
#> [58] 229 236
```

We can transform then into a vector to append to the file or to pass to
the lab mate with:

``` r
head(batch_names(index))
#> [1] "SubSet1" "SubSet3" "SubSet3" "SubSet2" "SubSet2" "SubSet4"
```

# Previous work

The CRAN task View of [Experimental
Design](https://CRAN.R-project.org/view=ExperimentalDesign) includes
many packages relevant for designing an experiment before collecting
data, but none of them provides how to manage them once the samples are
already collected.

Two packages allow to distribute the samples on batches:

- The
  [OSAT](https://bioconductor.org/packages/release/bioc/html/OSAT.html)
  package handles categorical variables but not numeric data. It doesn’t
  work with our data.

- The [minDiff](https://github.com/m-Py/minDiff) package reported in
  [Stats.SE](https://stats.stackexchange.com/a/326015/105234), handles
  both numeric and categorical data. But it can only optimize for two
  nominal criteria. It doesn’t work for our data.

- The [Omixer](https://bioconductor.org/packages/Omixer/) package
  handles both numeric and categorical data (converting categorical
  variables to numeric). But both the same way either Pearson’s
  Chi-squared Test if there are few samples or Kendall’s correlation. It
  does allow to protect some spots from being used.

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
