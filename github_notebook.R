# From this github notebook
# https://github.com/AndrewSkelton/Experimental-Design-Simulation/blob/master/Version2_Experiment.Rmd

library(tidyverse)
library(limma)

#' # First try
#'
#' Situation preparation
data.timepoints <- 6
data.treatments <- 2
data.cell.lines <- 9
data.replicates <- 6
data.batch.size <- 72
data.conditions <- data.timepoints * data.treatments * data.cell.lines
data.rows       <- 1e3
data.cols       <- data.conditions * data.replicates
data.no.batches <- data.cols / data.batch.size
data.no.samples <- data.timepoints * data.treatments * data.cell.lines * data.replicates
#' Preparation of the data
pheno.treatment <- paste0("TRT", LETTERS[1:data.treatments]) %>%
  rep(.,each = data.no.samples/data.treatments)
pheno.timepts   <- paste0("TP",  LETTERS[1:data.timepoints]) %>%
  rep(.,data.no.samples/data.timepoints)
pheno.replicate <- rep(1:data.replicates, each = data.timepoints) %>%
  rep(., data.treatments * data.cell.lines)
pheno.cell.line <- paste0("CL",  LETTERS[1:data.cell.lines])  %>%
  rep(., each = data.timepoints * data.replicates) %>%
  rep(., 2)

pheno.table     <- data.frame(Sample = paste0("SAM",1:data.no.samples)) %>%
  mutate(Treatment  = pheno.treatment,
         Time.Point = pheno.timepts,
         Replicate  = pheno.replicate,
         Cell.Line  = pheno.cell.line,
         SampleType = paste0(Treatment, "_", Time.Point, "_", Cell.Line)) %>%
  arrange(SampleType)
data.mat        <- rnorm(data.rows*data.cols, 7, 2) %>%
  matrix(ncol = data.cols) %>%
  `colnames<-`(pheno.table$Sample) %>%
  `rownames<-`(paste0("PROBE_",1:data.rows))

pheno.table$Treatment <- as.factor(pheno.table$Treatment)
pheno.table$Time.Point <- as.factor(pheno.table$Time.Point)
pheno.table$Cell.Line <- as.factor(pheno.table$Cell.Line)
pheno.table$SampleType <- as.factor(pheno.table$SampleType)

#' Output
summary(pheno.table)
sapply(pheno.table, function(x){length(table(table(x)))})

#' # Second try
#' Preparing the data
data.prop.split <- .5   # Proportion of replicate splits
data.batch.size <- 72   # Number of samples that can be ran on a single run
batch.bins      <- nrow(pheno.table)/data.batch.size
keep.seq        <- c(1:3,7:9,13:15,19:21,25:27,31:33)

samples.avail   <- pheno.table %>% group_by(SampleType) %>% summarise(N = n())

pheno.table$Batch <- 0
for(i in 1:batch.bins) {
  curr.batch.levels    <- 6
  idx.end              <- i*data.batch.size
  idx.start            <- (idx.end-data.batch.size)+1
  idx.range            <- idx.start:idx.end
  idx.keep             <- keep.seq[1:((data.replicates*data.prop.split)*curr.batch.levels)] + idx.start - 1
  pheno.table[idx.range,]$Batch <- i
  pheno.table[idx.keep,]$Batch  <- i-1
}
pheno.table <- pheno.table %>% mutate(Batch = ifelse(Batch == 0,1,Batch),
                                      Batch = as.factor(Batch))
pheno.table$Treatment <- as.factor(pheno.table$Treatment)
pheno.table$Time.Point <- as.factor(pheno.table$Time.Point)
pheno.table$Cell.Line <- as.factor(pheno.table$Cell.Line)
pheno.table$SampleType <- as.factor(pheno.table$SampleType)
#' Output
summary(pheno.table)
sapply(pheno.table, function(x){length(table(table(x)))})
#' # Conclusion
#' We can see that in both ideas, there is an equal number of each category for
#' all the data recorded, which is usually not the case, and definetly not my
#' case.
