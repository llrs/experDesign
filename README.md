# Design NGS

The goal of design_ngs is to help design the runs of a NGS run

# Input

It requires two types of information
 - Metadata: The information about the samples (age, sex, localization, RIN, personal, ...), 
 - Samples per batch: The maximum amount of samples per batch. This might be decided by barcode, or machine 

Optional input:
 - Allow technical duplicates? If some samples could be duplicated to fully occupy all batches and check if the same samples sequenced in several runs returns the same output.

# Output

The output is easy:

 - Namne and characteristics of each run: Which samples go together and how 
 
# Previous work


The [OSAT](https://bioconductor.org/packages/OSAT/) package handles categorical variables but not categorical data. It doesn't work with our data.

The [minDiff](https://github.com/m-Py/minDiff) package as an answer to a question in [Stats.SE](https://stats.stackexchange.com/a/326015/105234). It handles both numeric and categorical data. but it can only optimize fro two nominal criteria. It doesn't work for our data.

Question in [Bioinformatics.SE](https://bioinformatics.stackexchange.com/q/4765/48)

# Other

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md).
By participating in this project you agree to abide by its terms.
