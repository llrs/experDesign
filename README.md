
<!-- README.md is generated from README.Rmd. Please edit that file -->

# experDesign

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/experDesign)](https://CRAN.R-project.org/package=experDesign)
[![cran
checks](https://badges.cranchecks.info/worst/experDesign.svg)](https://cran.r-project.org/web/checks/check_results_experDesign.html)
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
experiment. It provides four main functions :

- `check_data()`: Check if there are any problems with the data.
- `design()`: Randomize the samples according to their variables.
- `replicates()`: Selects some samples for replicates and randomizes the
  samples (highly recommended).
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

# Example

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

## Checking initial data

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

## Picking samples for each batch

Imagine that we can only work in groups of 70, and we want to randomize
by Sex, Smoke, Age, and by hand.  
There are 1.6543999^{61} combinations of samples per batch in a this
experiment. However, in some of those combinations all the right handed
students are in the same batch making it impossible to compare the right
handed students with the others and draw conclusions from it.

We could check all the combinations to select those that allow us to do
this comparison. But as this would be too long with `experDesign` we can
try to find the combination with the best design by comparing each
combination with the original according to multiple statistics.

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

# Set a seed for reproducibility
set.seed(87732135)
# Looking for groups at most of 70 samples.
index <- design(pheno = survey, size_subset = 70, omit = omit, iterations = 100)
#> Warning: There might be some problems with the data use check_data().
index
#> $SubSet1
#>  [1]   3   9  10  14  16  21  23  24  25  30  44  46  56  57  59  62  63  68  69
#> [20]  70  73  80  81  85  90  94  95  97 101 103 104 105 106 111 113 119 123 125
#> [39] 139 143 151 155 164 168 174 177 178 188 190 191 200 202 210 216 224 228 229
#> [58] 232 234 237
#> 
#> $SubSet2
#>  [1]   5   6  11  18  19  22  31  34  37  38  39  40  41  47  49  53  54  55  58
#> [20]  60  65  66  71  74  84  91  96 100 108 124 126 127 133 134 144 145 148 158
#> [39] 159 160 161 162 166 169 180 185 186 193 198 199 203 204 205 208 214 215 226
#> [58] 231 235
#> 
#> $SubSet3
#>  [1]   1   2  13  15  26  27  36  42  48  50  51  52  61  64  67  72  76  77  78
#> [20]  86  92  98 102 107 110 115 117 118 120 121 130 136 138 140 141 142 147 156
#> [39] 167 171 173 176 184 189 194 196 197 206 209 211 212 217 218 219 221 222 227
#> [58] 230 233
#> 
#> $SubSet4
#>  [1]   4   7   8  12  17  20  28  29  32  33  35  43  45  75  79  82  83  87  88
#> [20]  89  93  99 109 112 114 116 122 128 129 131 132 135 137 146 149 150 152 153
#> [39] 154 157 163 165 170 172 175 179 181 182 183 187 192 195 201 207 213 220 223
#> [58] 225 236
```

We can transform then into a vector to append to the file or to pass to
a colleague with:

``` r
head(batch_names(index))
#> [1] "SubSet3" "SubSet3" "SubSet1" "SubSet4" "SubSet2" "SubSet2"
# Or via inspect() to keep it in a matrix format:
head(inspect(index, survey[, keep]))
#>      Sex W.Hnd Smoke    Age   batch
#> 1 Female Right Never 18.250 SubSet3
#> 2   Male  Left Regul 17.583 SubSet3
#> 3   Male Right Occas 16.917 SubSet1
#> 4   Male Right Never 20.333 SubSet4
#> 5   Male Right Never 23.667 SubSet2
#> 6 Female Right Never 21.000 SubSet2
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
