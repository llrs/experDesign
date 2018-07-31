[![Travis build status](https://travis-ci.org/llrs/experDesign.svg?branch=master)](https://travis-ci.org/llrs/experDesign)
[![Coverage status](https://codecov.io/gh/llrs/experDesign/branch/master/graph/badge.svg)](https://codecov.io/github/llrs/experDesign?branch=master)
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)

# experDesign

The goal of experDesign is to help design experiments in batches by 
distributing samples in each batch.

# Input

It requires two types of information:

 - Metadata: The information about the samples  
   This might be age, sex, localization, RIN, personal, ...  
 - Samples per batch: The maximum amount of samples per batch.  
  This might be decided by barcode, or machine if doing NGS.
  
That can be achived with the `design` function.

Optional input:

 - Allow technical duplicates?  
   If some samples could be duplicated to fully occupy all batches and check if the same samples sequenced in several runs returns the same output.

To account for technical duplicates use `replicates`.

# Output

The output is easy:

 - Name and characteristics of each run: Which samples go together.
 
# Previous work

The [OSAT](https://bioconductor.org/packages/OSAT/) package handles categorical variables but not numeric data. It doesn't work with our data.

The [minDiff](https://github.com/m-Py/minDiff) package reported in [Stats.SE](https://stats.stackexchange.com/a/326015/105234), handles both 
numeric and categorical data. But it can only optimize for two nominal criteria.
It doesn't work for our data.

Question in [Bioinformatics.SE](https://bioinformatics.stackexchange.com/q/4765/48)

# Other

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md).
By participating in this project you agree to abide by its terms.
