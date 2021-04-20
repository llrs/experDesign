---
title: "experDesign: helping performing experiments on batches"
output: 
  md_document:
    preserve_yaml: true
authors:
  - name: "Lluís Revilla Sancho"
    orcid: 0000-0001-9747-2570
    affiliation: '1, 2'
  - name: "Juan José Lozano Salvatella"
    orcid: 0000-0001-9747-2570
    affiliation: '1'
  - name: "Azucena Salas Martínez"
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
  - Batch effect
  - experiment design
bibliography: paper.bib
---

# Summary

The design of an experiment is critical for their success. However,
after an initial correct design the process till the measurement is
critical. At the several steps required from collection to measurement
many errors and problems might affect the experiment result. This
variation if not taken into account can make an experiment inconclusive.
*experDesign* provides tools to minimize the risk of making an
experiment inconclusive by assigning which samples go on which batch.

# Introduction

To properly design an experiment the source of variation between the
samples must be the one we are interested in. Usually one controls the
environment where the study or experiment is being done. Sometimes, this
is not enough or not possible, and then one need to apply some methods
to control these variation. There are three techniques used to reduce
unwanted variation: blocking, randomization and replication (Klaus
2015).

**Blocking** groups samples that are equal according to one or more
variables allowing to estimate the variation on the measurement from
these variables. **Randomization** is a method to get the average effect
by mixing the potential confounding variables. **Replication** increases
the number of samples used on the experiment to better estimate the
variation of the experiment. On some settings (clinical, agriculture, …)
several of these techniques are applied together to ensure the
robustness of the study.

Between the designing of an experiment and the measurement of the
samples many things can happen. If some samples go missing (or are
contaminated, or do not pass the quality control to perform the
measurement, or …) the unwanted variation of the experiment will
increase. Even if this doesn’t happen, sometimes the experiments need to
be done in batches because there are some technical; for example the
machine cannot measure more samples at once, or practical
considerations; for example it is not possible to take more measurements
on the field in the allowed time.

There are several techniques to identify and take into account batch
effects when analyzing an experiment already measured (Leek et al.
2010). However, if the source of them are not taken into account before
measuring they can introduce a batch effect that could be impossible to
remove. Therefore, it would be better if the batch effects were avoided
before carrying out the experiment. Tacking into account how the process
from the design to the measurement can introduce variability will help
avoiding batch effects.

To prevent the apparition of batch effect after the design of the
experiment there are two options: randomization and replication. This
techniques can prevent the batch effect to be able to compare between or
within the desired variable. One can do both of them but in any case it
must take into account the blocking design from the beginning or they
might further exacerbate the problem. For instance, if one designs an
experiment with cases and controls and the controls are measured in one
batch and the controls in a different batch then the difference between
them can be entirely confounded by a malfunction of the measurement
machine in one batch (Chen et al. 2011).

However, samples can be properly randomized to minimize the batch effect
by looking how the variables distribute on each batch, this is known as
randomized block experimental design or stratified random sampling
experimental design.

Replications consist on increasing the number of measurements with
similar attributes. Usually at least three samples are included for each
condition of interest to be able to estimate the variation of the
attributes. If there is one extraction and then a sample is measured
multiple times it is called a technical replicate. Technical replicates
help estimate the variation of the measurement method or the process.

# State of the art

There are some tools to prevent generating a batch effect on the R
language from multiple fields and areas, but specially on the biological
research (R Core Team 2014). They have some caveats that limit their
application to some cases and to our knowledge there hasn’t been a
comparison of these different methods. Here we describe existing
packages briefly:

-   *OSAT*, on [Bioconductor](https://bioconductor.org/packages/OSAT/),
    first allocates the samples on each batch according to a variable
    and later shuffles the samples on each batch to randomize the other
    variables (Yan et al. 2012). This algorithm relies on categorical
    variables and cannot use numeric ones such as age or time-related
    variables unless they are treated as categorical.

-   *minDiff*, on [github](https://github.com/m-Py/minDiff), and its
    successor *anticlust*, on
    [CRAN](https://cran.r-project.org/package=anticlust), divides the
    samples into similar groups, ensuring similarity by enforcing
    heterogeneity within group (Papenberg and Klau, n.d.). Conceptually
    it is similar to reversing the clustering methods k-means and
    cluster editing.

-   Recently, *Omixer*, a new package on
    [Bioconductor](https://bioconductor.org/packages/Omixer/), has been
    made available (Sinke, Cats, and Heijmans 2021). It tests if the
    random assignments are homogeneous transforming all variables to
    numeric and using the Kendall’s correlation if there are more than 5
    samples, otherwise using the Pearson chi-squared test.

-   Finally the package *experDesign*, on
    [CRAN](https://cran.r-project.org/package=experDesign), which
    provides groups with characteristics similar to the whole sample by
    comparing the random samples with the whole dataset for several
    statistics.

# Description

The package *experDesign* provides the function `design` to distribute
the samples on multiple batches so that each variable is homogeneous in
each batch. It is similar to the *anticluster* method for maximum
variance. If the experiment is carried out on a specific spatial
distribution the `spatial` function distributes the samples
homogeneously also by position similar to *Omixer*.

In addition to distribute the samples on batches *experDesign* provides
with tools to add technical replicates. When the design is already done
then the replicates are called technical replicates (Blainey,
Krzywinski, and Altman 2014). Technical replicates are samples that are
measured multiple times and allow to reduce the uncertainty of the
measurement. If the technical replicates are distributed on several
batches they allow to measure the batch effect and thus minimize it. To
select the technical replicates needed and choose from which samples
they are done the function `extreme_cases` is provided. For easier usage
the `replicates` designs an experiment with the number of replicates per
batch desired.

*experDesign* also provides several small utilities to make it easier
design the experiment in batches. For instance, it helps to calculate
the samples to distribute on the minimum number of batches required with
`sizes_batches`.

# Comparison

For completeness a brief examples using each different software.

First of all a brief data setup.

    data(cats, package = "MASS")
    cats$ID <- seq_len(nrow(cats))
    VoI <- c("Sex", "Bwt", "Hwt")
    n_batch <- 2
    iterations <- 10000

The objective is to group the cats in 2 groups to avoid any batch effect
on further measures on them. We set 10000 iterations and 2 groups

## OSAT

OSAT provides some template for some layouts:

    library("OSAT")
    gs <- setup.sample(cats, optimal = VoI)
    gc <- setup.container(IlluminaBeadChip96Plate, n = n_batch, batch = 'plates')
    gSetup <- create.optimized.setup(sample = gs, container = gc, nSim = iterations)
    ## Warning in create.optimized.setup(sample = gs, container = gc, nSim =
    ## iterations): Using default optimization method: optimal.shuffle

## anticlust

anticlust only works with numeric variables:

    library("anticlust")
    anticlust_index <- anticlustering(
      cats[, VoI],
      K = n_batch,
      objective = "variance",
      method = "exchange",
      repetitions = iterations
    )
    ## Error in validate_data_matrix(x): Your data (the first argument `x`) should only contain numeric entries, but this is not the case.
    anticlust_index <- anticlustering(
      cats[, c("Bwt", "Hwt")],
      K = n_batch,
      objective = "variance",
      method = "exchange",
      repetitions = iterations
    )

## Omixer

    library("Omixer")
    layout <- data.frame(well = 1:96, 
        row = factor(rep(1:8, each=12), labels = LETTERS[1:8]),
        column = rep(1:12, 8), 
        plate  = 1,
        chip = as.integer(ceiling(rep(1:12, 8)/2)))
    layout$chipPos <- ifelse(layout$column %% 2 == 0, 
                             as.numeric(layout$row) + 8,
                             layout$row)
    layout2 <- layout
    layout2$plate <- 2
    plates <- rbind(layout, layout2)
    Omixer_index <- omixerRand(cats, sampleId = "ID", 
        block = "none", iterNum = iterations, wells = 96,
        plateNum = n_batch, randVars = VoI, layout = plates, techVars = NULL)
    ## Error in omixerRand(cats, sampleId = "ID", block = "none", iterNum = iterations, : Number of unmasked wells must equal number of samples.

## experDesign

    library("experDesign")
    experDesign_index <- design(cats[, VoI], size_subset = 96,
                      iterations = iterations)

## Summary

Last we can compare some of the solutions

    OSAT_index <- get.experiment.setup(gSetup)$plates
    table(batch_names(experDesign_index), anticlust_index)
    ##          anticlust_index
    ##            1  2
    ##   SubSet1 36 36
    ##   SubSet2 36 36

    table(batch_names(experDesign_index), OSAT_index)
    ##          OSAT_index
    ##            1  2
    ##   SubSet1 34 38
    ##   SubSet2 38 34
    table(anticlust_index, OSAT_index)
    ##                OSAT_index
    ## anticlust_index  1  2
    ##               1 33 39
    ##               2 39 33

It doesn’t seem possible to run Omixer without any spatial batch effect

# References

Blainey, Paul, Martin Krzywinski, and Naomi Altman. 2014. “Replication.”
*Nature Methods* 11 (9): 879–80. <https://doi.org/10.1038/nmeth.3091>.

Chen, Chao, Kay Grennan, Judith Badner, Dandan Zhang, Elliot Gershon, Li
Jin, and Chunyu Liu. 2011. “Removing Batch Effects in Analysis of
Expression Microarray Data: An Evaluation of Six Batch Adjustment
Methods.” *PLOS ONE* 6 (2): e17238.
<https://doi.org/10.1371/journal.pone.0017238>.

Klaus, Bernd. 2015. “Statistical Relevancerelevant Statistics, Part i.”
*The EMBO Journal* 34 (22): 2727–30.
<https://doi.org/10.15252/embj.201592958>.

Leek, Jeffrey T., Robert B. Scharpf, Héctor Corrada Bravo, David Simcha,
Benjamin Langmead, W. Evan Johnson, Donald Geman, Keith Baggerly, and
Rafael A. Irizarry. 2010. “Tackling the Widespread and Critical Impact
of Batch Effects in High-Throughput Data.” *Nature Reviews. Genetics* 11
(10). <https://doi.org/10.1038/nrg2825>.

Papenberg, Martin, and Gunnar W. Klau. n.d. “Using Anticlustering to
Partition Data Sets into Equivalent Parts. - PsycNET.” *Psychological
Methods*. <https://doi.org/10.1037/met0000301>.

R Core Team. 2014. *R: A Language and Environment for Statistical
Computing*. Vienna, Austria: R Foundation for Statistical Computing.
<https://R-project.org/>.

Sinke, Lucy, Davy Cats, and Bastiaan T Heijmans. 2021. “Omixer:
Multivariate and Reproducible Sample Randomization to Proactively
Counter Batch Effects in Omics Studies.” *Bioinformatics*, no. btab159
(March). <https://doi.org/10.1093/bioinformatics/btab159>.

Yan, Li, Changxing Ma, Dan Wang, Qiang Hu, Maochun Qin, Jeffrey M.
Conroy, Lara E. Sucheston, et al. 2012. “OSAT: A Tool for
Sample-to-Batch Allocations in Genomics Experiments.” *BMC Genomics* 13
(1): 689. <https://doi.org/10.1186/1471-2164-13-689>.
