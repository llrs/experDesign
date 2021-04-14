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
after a correct design the collection of samples is a critical step
where many errors and problems might affect the experiment result.
Missing samples on experiments that must be carried out on batches might
impact the results if not taken into account. *experDesign* helps to
minimize batch effects for known variables assigning which samples go on
which batch.

# Introduction

Sometimes not tacking into account how some variable are blocking
creates batch effects on an experiment. There are several techniques to
identify and take into account batch effects when analyzing an
experiment (Leek et al. 2010). However, it would be better if the batch
effects could be avoided before carrying out the experiment. To avoid
creating them a good design of the experiment is needed. To design an
experiment three techniques are used to reduce unwanted variation:
blocking, randomization and replication (Klaus 2015).

**Blocking** groups samples that are equal according to one or more
variables allowing to estimate the variation on the measurement from
these variables. **Randomization** is a method to get the average effect
by mixing the potential confounding variables. **Replication** increases
the number of samples used on the experiment to better estimate the
variation of the experiment. On some settings (clinical, agriculture, …)
several of these techniques are applied together to ensure the
robustness of the study.

Between the designing of an experiment and the collection of the samples
many things can happen. If something goes wrong and some samples are
missing the unwanted variation of the experiment will increase.
Sometimes If the experiments needs to be done in batches and if not
taken into account on the design of the experiment it can introduce a
batch effect that can be impossible to remove from the data.

To prevent the batch effect there can be two options: randomization
and/or replication. If the practitioner goes with randomization or
replication they must take into account the blocking design from the
beginning or they might further exacerbate the problem. For instance, if
cases and controls are measured in different batches, sample variation
can be entirely confounded by this (Chen et al. 2011). Samples can be
properly randomized to minimize the batch effect by looking how the
variables distribute on each batch, on what it is known as randomized
blocked/ stratified sampling experimental design.

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
    [CRAN](https://cran.r-project.org/package=anticlust), (“Using
    Anticlustering to Partition Data Sets into Equivalent Parts. -
    PsycNET,” n.d.) divides the samples into similar groups, ensuring
    similarity by enforcing heterogeneity within group. Conceptually it
    is similar to reversing the clustering methods k-means and cluster
    editing.

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
select the technical replicates needed and from which samples the
function `extreme_cases` is provided. For easier usage the `replicates`
designs an experiment with the number of replicates per batch desired.

*experDesign* also provides several small utilities to make it easier
design the experiment in batches. For instance, it helps to calculate
the samples to distribute on the minimum number of batches required with
`sizes_batches`.

# References

Blainey, Paul, Martin Krzywinski, and Naomi Altman. 2014. “Replication.”
*Nature Methods* 11 (9): 879–80. <https://doi.org/10.1038/nmeth.3091>.

———. 2014. “Replication.” *Nature Methods* 11 (9): 879–80.
<https://doi.org/10.1038/nmeth.3091>.

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

R Core Team. 2014. *R: A Language and Environment for Statistical
Computing*. Vienna, Austria: R Foundation for Statistical Computing.
<https://R-project.org/>.

Sinke, Lucy, Davy Cats, and Bastiaan T Heijmans. 2021. “Omixer:
Multivariate and Reproducible Sample Randomization to Proactively
Counter Batch Effects in Omics Studies.” *Bioinformatics*, no. btab159
(March). <https://doi.org/10.1093/bioinformatics/btab159>.

“Using Anticlustering to Partition Data Sets into Equivalent Parts. -
PsycNET.” n.d. <https://doi.apa.org/doiLanding?doi=10.1037>.

Yan, Li, Changxing Ma, Dan Wang, Qiang Hu, Maochun Qin, Jeffrey M.
Conroy, Lara E. Sucheston, et al. 2012. “OSAT: A Tool for
Sample-to-Batch Allocations in Genomics Experiments.” *BMC Genomics* 13
(1): 689. <https://doi.org/10.1186/1471-2164-13-689>.
