---
title: 'experDesign: stratifying samples into batches with minimal bias'
output:
  word_document:
    keep_md: yes
  md_document:
    preserve_yaml: yes
  pdf_document: default
  html_document:
    df_print: paged
date: "15th July 2021"
affiliations:
- name: Centro de Investigación Biomédica en Red, Enfermedades Hepáticas y Digestivas
  index: 1
- name: Institut d'Investigacions Biomèdiques August Pi i Sunyer, IDIBAPS
  index: 2
authors:
- name: Lluís Revilla Sancho
  orcid: 0000-0001-9747-2570
  affiliation: 1, 2
- name: Juan-José Lozano
  orcid: 0000-0001-9747-2570
  affiliation: '1'
- name: Azucena Salas
  orcid: 0000-0001-9747-2570
  affiliation: '2'
tags:
- R
- batch effect
- experiment design
bibliography: paper.bib
---



# Summary

The design of an experiment is critical to its success.
Nonetheless, even with a correct design, the process up to the moment of measurement is critical.
At any one of the several steps required from collection to measurement various errors and problems could affect the experimental results.
Failure to take such variability into account can render an experiment inconclusive.
*experDesign* provides tools to minimize the risk of inconclusive results by assigning samples to batches to minimize potential batch effects.

# Introduction

To properly design an experiment, the source of the variation between samples must be identified.
Typically, one can control the environment in which the study or experiment is being conducted.
Sometimes, however, this is not possible, and then one needs to apply certain techniques to control for such variations.
There are three techniques used to decrease the uncertainty of the unwanted variation: blocking, randomization and replication [@klaus2015].

**Blocking** groups samples that are equal according to one or more variables, allowing one to estimate the differences between each batch by comparing measurements within blocks.
**Randomization** minimizes the variation in the measurements by mixing the potential confounding variables.
**Replication** increases the number of samples used in an experiment to better estimate the variation of the experiment.
In some settings these techniques can be applied together to ensure the robustness of the study.

Between the designing of an experiment and the measurement of the samples, some samples might be lost, be contaminated, or degradation below quality threshold can happen.
Even if this does not happen, experiments will occasionally need to be carried out in batches.
Batches might be due to technical reasons, for example, the machine cannot measure more than some amount of samples at a time; and practical reasons, for instance, it may not be possible to obtain additional measurements in the field during the allotted time.

This divergence from the original design might cause batch effects perturbing the analysis.
There are several techniques to identify and assess batch effects when analyzing an already measured experiment [@leek2010].
However, if the source of variations is not taken into account before measurement is completed, a batch effect can be introduced that confounds the analysis.
Thus, it would be better to avoid such batch effects before executing an experiment.

To prevent the batch effect to confound an analysis after the initial design of the experiment, there are two options: randomization and replication.
Randomization, can help reduce variations across groups, while replication helps estimate the variation of the measurements or samples, thus increasing the precision of the estimates of the true value on the analysis.
Replications consist of increasing the number of measurements with similar attributes.
When a sample is measured multiple times, this is referred to as a technical replicate.
Technical replicates help estimate the variation of the measurement method, and thus the possible batch effect [@blainey2014].

Randomization and replicates can be used to prevent batch effects to confound the analysis.
However, by examining how the variables are distributed across each batch, proper randomization can be ensured, thus minimizing batch effects.
This is known as randomized block experimental design or stratified random sampling experimental design.

# State of the art

There are some tools to minimize batch effects on the R language in multiple fields and areas, and particularly for biological research [@rcoreteam2014].
Here we briefly describe the currently available packages:

-   *OSAT*, at [Bioconductor](https://bioconductor.org/packages/OSAT/), first allocates the samples from each batch according to a variable; it then shuffles the samples from each batch in order to randomize the other variables [@yan2012].
    This algorithm relies on categorical variables and cannot use numerical variables (e.g., age- or time-related) unless they are treated as categorical.

-   *minDiff*, at [github](https://github.com/m-Py/minDiff), and its successor *anticlust*, at [CRAN](https://cran.r-project.org/package=anticlust), divides the samples into similar groups, ensuring similarity by enforcing heterogeneity within groups [@papenberg2020].
    Conceptually it is similar to the clustering methods k-means.

-   Recently, *Omixer*, a new package, has recently been made available at [Bioconductor](https://bioconductor.org/packages/Omixer/) [@sinke2021].
    It tests whether the random assignments are homogeneous by transforming all variables to numeric values and using the Kendall's correlation when there are more than 5 samples; otherwise, it utilizes the Pearson's chi-squared test.

# Statement of need

Current solutions to stratify samples to reduce and control batch effect do not work for all cases and usual needs of researchers.
They are either specialized to specific type of data or omit some conditions that are often meet or only work on a specific subset of conditions.
The new package ***experDesign*** works on all kind of data types and doesn't require a spatial distribution making it suitable for all kind of experiments.
This package is intended for people looking for a quick easy to interpret solution providing reasonable suggestions about how to distribute the samples on their analysis.

For completeness a description and comparison of the usage of the different software currently available on CRAN and Bioconductor is presented below.
First some real data from a survey:


```r
data(survey, package = "MASS")
survey$ID <- seq_len(nrow(survey))
VoI <- c("Sex", "Smoke", "Age")
n_batch <- 3
size_subset <- 96
iterations <- 1000
```

This data set has three variables of interest; Sex, Smoke and Age are a mix of categorical and numeric variables.

## OSAT

OSAT provides some template for some setups and works for numeric and categorical variables:


```r
library("ggplot2")
library("OSAT")
library("patchwork")
gs <- setup.sample(survey, optimal = VoI)
gc <- setup.container(plate = IlluminaBeadChip96Plate, n = n_batch, batch = 'plates')
gSetup <- create.optimized.setup(sample = gs, container = gc, nSim = iterations)
## Warning in create.optimized.setup(sample = gs, container = gc, nSim =
## iterations): Using default optimization method: optimal.shuffle
osat_report <- get.experiment.setup(gSetup)
nrow(osat_report)
## [1] 236
osat_age <- ggplot(osat_report) +
  geom_histogram(aes(Age, fill = as.character(plates))) +
  facet_wrap(~plates) +
  labs(fill = "Batch")
osat_sex <- ggplot(osat_report) +
  geom_bar(aes(Sex, fill = as.character(plates))) +
  facet_wrap(~plates) +
  labs(fill = "Batch")
osat_smoke <- ggplot(osat_report) +
  geom_bar(aes(Smoke, fill = as.character(plates))) +
  facet_wrap(~plates) +
  labs(fill = "Batch")
(osat_smoke/(osat_age + osat_sex + plot_layout(guides = 'collect'))) +
  plot_annotation(title = "OSAT")
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

![](paper_files/figure-docx/osat-1.png)<!-- -->

OSAT returns one row less that the input provided because it deletes one row because it has an NA value on the Sex variable.

## anticlust

anticlust doesn't handle all the variables, it only accepts numeric variables:


```r
library("anticlust")
anticlust_index <- anticlustering(
  survey[, VoI],
  K = n_batch,
  objective = "variance",
  method = "exchange",
  repetitions = iterations
)
## Error in validate_data_matrix(x): Your data (the first argument `x`) should only contain numeric entries, but this is not the case.
anticlust_index <- anticlustering(
  survey[, "Age"],
  K = n_batch,
  objective = "variance",
  method = "exchange",
  repetitions = iterations
)
report_anticlust <- data.frame(Age = survey[, "Age"], batch = as.character(anticlust_index))
library("ggplot2")
ggplot(report_anticlust) + 
  geom_histogram(aes(Age, fill = batch)) +
  facet_wrap(~batch) +
  labs(fill = "Batch", title = "anticlust")
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

![](paper_files/figure-docx/anticlust-1.png)<!-- -->

## Omixer

There is a bug on Omixer that prevents it to work unless specific conditions are meet.
That prevents it comparing with the other tools using the same settings:


```r
library("Omixer")
survey$ID <- seq_len(nrow(survey))
Omixer_index <- omixerRand(survey, sampleId = "ID", 
                           block = "block", iterNum = 10, wells = size_subset, 
                           plateNum = n_batch, randVars = VoI, techVars = NULL)
## Error in omixerRand(survey, sampleId = "ID", block = "block", iterNum = 10, : Number of unmasked wells must equal number of samples.
Omixer_index <- omixerRand(survey, sampleId = "ID", 
                           block = "block", iterNum = 10, wells = size_subset, mask = rep(1, nrow(survey)),
                           plateNum = n_batch, randVars = VoI, techVars = NULL)
## Error: Tibble columns must have compatible sizes.
## * Size 288: Existing data.
## * Size 237: Column `mask`.
## ℹ Only values of size one are recycled.
Omixer_index <- omixerRand(survey, sampleId = "ID", 
                           block = "block", iterNum = 10, wells = size_subset, mask = rep(0, nrow(survey)),
                           plateNum = n_batch, randVars = VoI, techVars = NULL)
## Error: Tibble columns must have compatible sizes.
## * Size 288: Existing data.
## * Size 237: Column `mask`.
## ℹ Only values of size one are recycled.
Omixer_index <- omixerRand(survey, sampleId = "ID", 
                           block = "block", iterNum = 10, wells = size_subset, mask = rep(1, 288),
                           plateNum = n_batch, randVars = VoI, techVars = NULL)
## Error in omixerRand(survey, sampleId = "ID", block = "block", iterNum = 10, : Number of unmasked wells must equal number of samples.
Omixer_index <- omixerRand(survey, sampleId = "ID", 
                           block = "block", iterNum = 10, wells = size_subset, mask = rep(0, 288),
                           plateNum = n_batch, randVars = VoI, techVars = NULL)
## Error in omixerRand(survey, sampleId = "ID", block = "block", iterNum = 10, : Number of unmasked wells must equal number of samples.
```

# Description

The package ***experDesign*** provides the functional `design` to distribute the samples into multiple batches such that each variable is homogeneous within each batch.
Each batch is set to have some centrality and dispersion statistics to match as closely as possible the original input design data.
It does by comparing the mean, the standard deviation, the median absolute deviation, variables with no value number, the entropy and the independence of the categorical variables.
On each iteration if the distribution of samples for each batch has less differences with the original distribution than the last previous stored sample distribution then it replace it as the best sample distribution.
At the end of the iterations the best sample distribution is returned to the user.


```r
library("experDesign")
experDesign_index <- design(survey[, VoI], size_subset = size_subset,
                  iterations = iterations)
experDesign_index_spatial <- spatial(index = experDesign_index, pheno = survey[, VoI], 
                                     iterations = iterations, rows = LETTERS[1:8], columns = 1:12)
experDesign_report <- inspect(experDesign_index, survey[, VoI])
nrow(experDesign_report)
## [1] 237
experDesign_age <- ggplot(experDesign_report) + 
  geom_histogram(aes(Age, fill = batch)) +
  facet_wrap(~batch) +
  labs(fill = "Batch")
experDesign_sex <- ggplot(experDesign_report) +
  geom_bar(aes(Sex, fill = batch)) +
  facet_wrap(~batch) +
  labs(fill = "Batch")
experDesign_smoke <- ggplot(experDesign_report) +
  geom_bar(aes(Smoke, fill = batch)) +
  facet_wrap(~batch) +
  labs(fill = "Batch")
(experDesign_smoke/(experDesign_age + experDesign_sex + plot_layout(guides = 'collect'))) + plot_annotation(title = "experDesign")
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

![](paper_files/figure-docx/experDesign-1.png)<!-- -->

One can check the statistics of the index for multiple statistics:


```r
evaluate_na(experDesign_index, survey[, VoI])
##       Sex     Smoke       Age 
## 0.4444444 0.4444444 0.0000000
evaluate_entropy(experDesign_index, survey[, VoI])
##        Sex      Smoke 
## 0.02010158 0.48623934
evaluate_mad(experDesign_index, survey[, VoI])
##     Age 
## 25.9455
evaluate_sd(experDesign_index, survey[, VoI])
##       Age 
## 0.8443524
evaluate_mean(experDesign_index, survey[, VoI])
##       Age 
## 0.1441744
# All together for each batch
ei <- evaluate_index(experDesign_index, survey[, VoI])
ei[, , "SubSet1"]
##          variables
## stat            Sex     Smoke       Age
##   mean    0.0000000 0.0000000 20.443101
##   sd      0.0000000 0.0000000  6.612579
##   mad     0.0000000 0.0000000  1.605656
##   na      0.0000000 0.0000000  0.000000
##   entropy 0.9663341 0.4950901  0.000000
evaluate_na(experDesign_index_spatial, survey[, VoI])
##        Sex      Smoke        Age 
## 0.02061632 0.02061632 0.00000000
evaluate_entropy(experDesign_index_spatial, survey[, VoI])
##       Sex     Smoke 
## 0.3926691 1.0000000
evaluate_mad(experDesign_index_spatial, survey[, VoI])
##      Age 
## 25.69664
evaluate_sd(experDesign_index_spatial, survey[, VoI])
##      Age 
## 5.085115
evaluate_mean(experDesign_index_spatial, survey[, VoI])
##     Age 
## 2.25844
# All together for each batch
ei <- evaluate_index(experDesign_index_spatial, survey[, VoI])
ei[, , "G1"]
##          variables
## stat      Sex Smoke        Age
##   mean      0     0 18.2780000
##   sd        0     0  0.1273303
##   mad       0     0  0.1230558
##   na        0     0  0.0000000
##   entropy   0     0  0.0000000
```

And compare it with the original distribution:


```r
evaluate_orig(survey[, VoI])
##         Sex     Smoke       Age
## mean      0 0.0000000 20.374515
## sd        0 0.0000000  6.474335
## mad       0 0.0000000  1.605656
## na        1 1.0000000  0.000000
## entropy   1 0.5143828  0.000000
```

In ***experDesign*** the difference is used to compare with the original distribution, this approach is similar to the *anticlust* method used for maximum variance, but instead of the difference with the original distribution the objective function is the sum of the squared errors between cluster centers and individual data points and instead of comparing to the clusters center it is compared to the whole data.
If the experiment is carried out with a specific spatial distribution, the `spatial` function also distributes the samples homogeneously by position.
See below for an example.

In addition to distributing the samples into batches, ***experDesign*** provides tools to add technical replicates.
In order to choose them from the available samples, the function `extreme_cases` is provided.
For easier usage, the `replicates` function designs an experiment with the number of replicates per batch desired.


```r
extreme_cases(survey[, VoI], size = 5)
## [1]  33  43  79 154 211
replicates_index <- replicates(pheno = survey[, VoI], 
                               size_subset = size_subset, controls = 5, 
                               iterations = iterations)
spatial_replicate_index <- spatial(index = replicates_index, pheno = survey[, VoI], 
                                   rows = LETTERS[1:8], columns = 1:12)
survey$ID <- seq_len(nrow(survey))
report_replicates <- inspect(i = replicates_index, 
                             pheno = survey[, c(VoI, "ID")])
report_replicates_position <- inspect(i = spatial_replicate_index, 
                             pheno = report_replicates, 
                             index_name = "position")
# Batch and position where the samples should be:
head(report_replicates_position)
##      Sex Smoke    Age ID   batch position
## 1 Female Never 18.250  1 SubSet2       E2
## 2   Male Regul 17.583  2 SubSet3       D3
## 3   Male Occas 16.917  3 SubSet1       B3
## 4   Male Never 20.333  4 SubSet1       C5
## 5   Male Never 23.667  5 SubSet2       D6
## 6 Female Never 21.000  6 SubSet1       D5
# Technical replicates:
head(report_replicates_position[duplicated(report_replicates_position$ID), ])
##          Sex Smoke    Age  ID   batch position
## 166.3 Female Never 18.500 166 SubSet1       A3
## 166.4 Female Never 18.500 166 SubSet1       C5
## 166.1 Female Never 18.500 166 SubSet2       C3
## 166.2 Female Never 18.500 166 SubSet3       E5
## 169.1   Male Never 17.417 169 SubSet1       G2
## 169.2   Male Never 17.417 169 SubSet1       G5
```

***experDesign*** also provides several small utilities to make it easier to design the experiment in batches.
For instance, a function called `sizes_batches` helps calculate the number of samples in order to distribute them across the number of batches required and another one calculates the minimal amount of batches required:


```r
optimum_batches(size_data = 250, size_subset = 96)
## [1] 3
sizes_batches(size_data = 250, size_subset = 96, batches = 3)
## [1] 84 83 83
```

In conclusion the ***experDesign*** can be a first fast step to prepare for a batch experiment.
It can use as many numeric and categorical variables as needed to stratify the experiment design on batches including spatial distributions.

# Acknowledgments

We are grateful to Joe Moore for English-language assistance.

# References
