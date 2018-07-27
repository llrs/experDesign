#' ---
#' title: "Experimental design of Michigan sequencing"
#' author: "Lluís Revilla"
#' date: "r `date() `"
#' output: html_document
#' ---
#' # Load data

trim <- readRDS("../TRIM/meta_r_full.RDS")
bcn <- readRDS("../BCN/meta_BCN_full.RDS")

#' # Clean the data
#'
#' Removes the unwanted columns for plate organization
keep <- colnames(bcn)[-c(
  2, 3, 4, 5, 6, 8, 15, 16, 17, 22, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35,
  36, 37, 38, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56,
  57, 58)]
bcn <- bcn[, keep]

keep <- colnames(trim)[-c(4, 5, 6, 8, 13, 15, 16, 17, 23)]
trim <- trim[, keep]

#' # Match column names
#'
#' This piece of code should match the content and column names of the two data
#' frames, in order to be able to merge them accordingly
colnames(bcn) <- gsub("gender", "SEX", colnames(bcn), ignore.case = TRUE)
trim$Exact_location <- tolower(gsub(" COLON", "", trim$Exact_location))
trim$ID <- ifelse(grepl("^C", as.character(trim$ID)),
                  as.character(trim$ID),
                  paste0("T-", as.character(trim$ID)))
trim$Study <- "HSCT"
bcn$Study <- "BCN"
bcn$Pacient_id <- ifelse(grepl("^C", as.character(bcn$Pacient_id)),
                  gsub("-.*", "",as.character(bcn$Pacient_id)),
                  paste0("B-", as.character(bcn$Pacient_id)))
levels(bcn$IBD) <- c("CD", "CONTROL", "UC")

common <- c("Treatment", "IBD", "SEX", "Study")
pheno <- merge(trim, bcn, by.x = c("Sample Name_RNA", common, "Exact_location",
                                   "AgeDiag", "ID"),
               by.y = c("Sample_id", common, "biopsied_segment",
                        "Diagnostic age", "Pacient_id") , all = TRUE)

pheno$SEX <- as.factor(tolower(pheno$SEX))
pheno <- pheno[!duplicated(pheno$`Sample Name_RNA`), ]
dim(pheno) # Should be 380 samples
table(pheno$IBD, pheno$Study)

saveRDS(pheno, "samples2sequence.RDS")
#' This should match with 51 CONTROLS (They are used for both studies),
#' 115 CD of HSCT, 205 (CD+UC),
#'
#' # Classify by plates
#'
#' The aimed plate is also 96, so we can use the
#' [OSAT](https://bioconductor.org/packages/OSAT/) package. However we need to
#' remove teh numeric values in order to use it:
library("OSAT")
#' error=FALSE
gs <- setup.sample(pheno, optimal=c("Sample Name_RNA", "IBD", "SEX", "Study",
                                    "ID", "Exact_location"))
gc <- setup.container(IlluminaBeadChip96Plate, 6, batch='plates')
gSetup <- create.optimized.setup(sample=gs, container=gc, nSim=1000)
QC(gSetup)
