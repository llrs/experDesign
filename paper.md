---
title: "experDesign: helping performing experiments on batches"
output: 
  word_document: 
    keep_md: true
  md_document:
    preserve_yaml: true
authors:
  - name: "Lluís Revilla Sancho"
    orcid: 0000-0001-9747-2570
    affiliation: '1, 2'
  - name: "Juan-José Lozano"
    orcid: 0000-0001-9747-2570
    affiliation: '1'
  - name: "Azucena Salas"
    orcid: 0000-0001-9747-2570
    affiliation: '2'
affiliations:
  - name: "Centro de Investigación Biomédica en Red, Enfermedades Hepáticas y Digestivas"
    index: 1
  - name: "Institut d'Investigacions Biomèdiques August Pi i Sunyer, IDIBAPS"
    index: 2
date: Sys.Date()
tags:
  - R
  - batch effect
  - experiment design
bibliography: paper.bib
---

# Summary

The design of an experiment is critical for their success.
However, after an initial correct design the process till the measurement is critical.
At the several steps required from collection to measurement many errors and problems might affect the experiment result.
This variation if not taken into account can make an experiment inconclusive.
*experDesign* provides tools to minimize the risk of making an experiment inconclusive by assigning which samples go on which batch.

# Introduction

To properly design an experiment the source of variation between the samples must be the one we are interested in.
Usually one controls the environment where the study or experiment is being done.
Sometimes, this is not enough or not possible, and then one need to apply some methods to control these variation.
There are three techniques used to reduce unwanted variation: blocking, randomization and replication [@klaus2015].

**Blocking** groups samples that are equal according to one or more variables allowing to estimate the variation on the measurement from these variables.
**Randomization** is a method to get the average effect by mixing the potential confounding variables.
**Replication** increases the number of samples used on the experiment to better estimate the variation of the experiment.
On some settings (clinical, agriculture, ...) several of these techniques are applied together to ensure the robustness of the study.

Between the designing of an experiment and the measurement of the samples many things can happen.
If some samples go missing (or are contaminated, or do not pass the quality control to perform the measurement, or ...) the unwanted variation of the experiment will increase.
Even if this doesn't happen, sometimes the experiments need to be done in batches because there are some technical; for example the machine cannot measure more samples at once, or practical considerations; for example it is not possible to take more measurements on the field in the allowed time.

There are several techniques to identify and take into account batch effects when analyzing an experiment already measured [@leek2010].
Experiments that run over long periods of time or are run across different laboratories are highly likely to be susceptible and even smaller single-laboratory studies if spanned several days or include personnel changes may be affected.
However, if the source of them are not taken into account before measuring they can introduce a batch effect that could be impossible to remove.
Therefore, it would be better if the batch effects were avoided before carrying out the experiment.
Tacking into account the process from the design to the measurement can help to avoid batch effects.

Experiments should be designed to distribute batches and other potential sources of experimental variation across groups.
To prevent the apparition of batch effect after the initial design of the experiment there are two options: randomization and replication.
This techniques can prevent the batch effect and allow to compare between or within the desired variable(s).
One can do both of them but in any case it must take into account the blocking design from the beginning or they might further exacerbate the problem.

Randomization if done correctly helps reducing the variation across groups while replication let us be more confident of the result of the experiment.
For instance, if one designs an experiment with cases and controls and the controls are measured in one batch and the controls in a different batch then the difference between them can be entirely confounded by a malfunction of the measurement machine in one batch [@chen2011].
However, by looking how the variables distribute on each batch samples can be properly randomized to minimize the batch effect, this is known as randomized block experimental design or stratified random sampling experimental design.

Replications consist on increasing the number of measurements with similar attributes.
Usually at least three samples are included for each condition of interest to be able to estimate the variation of the attributes.
If there is one extraction and then a sample is measured multiple times it is called a technical replicate.
Technical replicates help estimate the variation of the measurement method and thus of the possible batch effect.

# State of the art

There are some tools to prevent generating a batch effect on the R language from multiple fields and areas, but specially on the biological research [@rcoreteam2014].
They have some caveats that limit their application to some cases and to our knowledge there hasn't been a comparison of these different methods.
Here we describe the current packages briefly:

-   *OSAT*, on [Bioconductor](https://bioconductor.org/packages/OSAT/), first allocates the samples on each batch according to a variable and later shuffles the samples on each batch to randomize the other variables [@yan2012].
    This algorithm relies on categorical variables and cannot use numeric ones such as age or time-related variables unless they are treated as categorical.

-   *minDiff*, on [github](https://github.com/m-Py/minDiff), and its successor *anticlust*, on [CRAN](https://cran.r-project.org/package=anticlust), divides the samples into similar groups, ensuring similarity by enforcing heterogeneity within group [@papenberg].
    Conceptually it is similar to reversing the clustering methods k-means and cluster editing.

-   Recently, *Omixer*, a new package on [Bioconductor](https://bioconductor.org/packages/Omixer/), has been made available [@sinke2021].
    It tests if the random assignments are homogeneous transforming all variables to numeric and using the Kendall's correlation if there are more than 5 samples, otherwise using Pearson's chi-squared test.

-   Finally the package *experDesign*, on [CRAN](https://cran.r-project.org/package=experDesign), which provides groups with characteristics similar to the whole sample by comparing the random samples with the whole dataset for several statistics.

# Description

The package ***experDesign*** provides the function `design` to distribute the samples on multiple batches so that each variable is homogeneous in each batch.
It is similar to the *anticluster* method for maximum variance.
If the experiment is carried out on a specific spatial distribution the `spatial` function distributes the samples homogeneously also by position similar to *Omixer*.

In addition to distribute the samples on batches ***experDesign*** provides with tools to add technical replicates.
When the design is already done then the replicates are called technical replicates [@blainey2014].
Technical replicates are samples that are measured multiple times and allow to reduce the uncertainty of the measurement.
If the technical replicates are distributed on several batches they allow to measure the batch effect and thus minimize it.
To select the technical replicates needed and choose from which samples they are done the function `extreme_cases` is provided.
For easier usage the `replicates` designs an experiment with the number of replicates per batch desired.

***experDesign*** also provides several small utilities to make it easier design the experiment in batches.
For instance, it helps to calculate the samples to distribute on the minimum number of batches required with `sizes_batches`.

# References
