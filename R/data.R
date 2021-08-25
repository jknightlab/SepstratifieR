#' Whole blood gene expression measurements from 3,264 individuals
#'
#' A data set containing gene expression measurements from whole blood for the 7 SRS signature genes.
#'
#' This data set is formed of 1,609 samples from healthy individuals and 1,655 samples from sepsis patients.
#'
#' Sepsis patients were recruited as a part of the Genomic Advances in Sepsis (GAinS) study in Oxford, UK. Of these, 676 were profiled using the Illumina HumanHT microarray, 864 using polyA-based RNA-sequencing, and 115 using qPCR.
#'
#' Healthy individual data was collected from a number of publicly available sources. In particular, 991 OIllumina HumanHT microarray samples were obtained from the SHIP-TREND consortium, 518 Illumina HumanHT microarray samples were obatained from the DILGOM cohort (an extension of the FINRISK study), and 100 polyA-based RNA-sequencing samples were obtained from the dutch 500FG cohort
#'
#' RNa-seq data was log-transformed and any relevant batch effects were removed using the combat algorithm.
#' Finally, the 7 SRS signature genes were extracted from each cohort and the data was integrated together using the mutual nearest neighbout (mNN) algorithm.
#'
#' The values reported in this data set were obtained after mNN alignment, and thus they represent Cosine-scale batch-corrected values.
#'
#'
#' The main use of this data set is to serve as a reference to which new input samples can be aligned before prediction of SRS group using random forest models.
#'
#'
#' @format A data frame with 3264 rows and 7 variables:
#' \describe{
#'   \item{ENSG00000152219}{ARL14EP, cosine-scaled, batch corrected gene expression level}
#'   \item{ENSG00000100814}{CCNB1IP1, cosine-scaled, batch corrected gene expression level}
#'   \item{ENSG00000127334}{DYRK2, cosine-scaled, batch corrected gene expression level}
#'   \item{ENSG00000131355}{ADGRE3, cosine-scaled, batch corrected gene expression level}
#'   \item{ENSG00000137337}{MDC1, cosine-scaled, batch corrected gene expression level}
#'   \item{ENSG00000156414}{TDRD9, cosine-scaled, batch corrected gene expression level}
#'   \item{ENSG00000115085}{ZAP70, cosine-scaled, batch corrected gene expression level}
#'
#'   ...
#' }
"reference_set"

#' Metadata for the whol eblood gene expression data set
#'
#' A data set containing additional information for the 3,264 individuals contained in the referenc set.
#'
#' It is formed of 5 variables gathered for 3,264 individuals
#'
#' This data set is useful for visualisations and is called internally by the plotting function plotAlignedSamples().
#'
#'
#' @format A data frame with 3264 rows and 5 variables:
#' \describe{
#'   \item{Study}{Cohort or study from which the samples were originally obtained}
#'   \item{Assay}{Type of technology used to measure gene expresison in that sample}
#'   \item{SRS}{Predicted sepsis response signature (SRS) group for that sample}
#'   \item{SRSq}{Predicted sepsis response signature score (SRSq) for that sample}
#'   \item{mNN_outlier}{Indicates whether the sample is outlying. (FALSE for all samples in the reference set).}
#'   ...
#' }
"reference_set_annotations"

#' Whole blood gene expression measurements from 3,264 individuals
#'
#' A data set containing gene expression measurements from whole blood for the 7 SRS signature genes.
#'
#' This data set is formed of 1,609 samples from healthy individuals and 1,655 samples from sepsis patients.
#'
#' Sepsis patients were recruited as a part of the Genomic Advances in Sepsis (GAinS) study in Oxford, UK. Of these, 676 were profiled using the Illumina HumanHT microarray, 864 using polyA-based RNA-sequencing, and 115 using qPCR.
#'
#' Healthy individual data was collected from a number of publicly available sources. In particular, 991 OIllumina HumanHT microarray samples were obtained from the SHIP-TREND consortium, 518 Illumina HumanHT microarray samples were obatained from the DILGOM cohort (an extension of the FINRISK study), and 100 polyA-based RNA-sequencing samples were obtained from the dutch 500FG cohort
#'
#' RNa-seq data was log-transformed and any relevant batch effects were removed using the combat algorithm.
#' Finally, the 7 SRS signature genes were extracted from each cohort and the data was integrated together using the mutual nearest neighbout (mNN) algorithm.
#'
#' The values reported in this data set were obtained after mNN alignment, and thus they represent Cosine-scale batch-corrected values.
#'
#'
#' The main use of this data set is to serve as a reference to which new input samples can be aligned before prediction of SRS group using random forest models.
#'
#'
#' @format A data frame with 3264 rows and 7 variables:
#' \describe{
#'   \item{ENSG00000152219}{ARL14EP, cosine-scaled, batch corrected gene expression level}
#'   \item{ENSG00000100814}{CCNB1IP1, cosine-scaled, batch corrected gene expression level}
#'   \item{ENSG00000127334}{DYRK2, cosine-scaled, batch corrected gene expression level}
#'   \item{ENSG00000131355}{ADGRE3, cosine-scaled, batch corrected gene expression level}
#'   \item{ENSG00000137337}{MDC1, cosine-scaled, batch corrected gene expression level}
#'   \item{ENSG00000156414}{TDRD9, cosine-scaled, batch corrected gene expression level}
#'   \item{ENSG00000115085}{ZAP70, cosine-scaled, batch corrected gene expression level}
#'
#'   ...
#' }
"reference_set"


#' Whole blood gene expression measurements of 25 individuals
#'
#' A data set containing gene expression measurements from whole blood for the 7 SRS signature genes.
#'
#' This data set is formed of 25 patients randomly selected from the COVID-19 Multi-omics Blood Atlas (COMBAT) study (Oxford, UK).
#'
#' The values reported in this data set were obtained after batch correction and log transformation of the raw RNA-seq counts.
#'
#' The main use of this data set is to serve as a small test set with which to test the functionality of this package.
#'
#'
#' @format A data frame with 25 rows and 7 variables:
#' \describe{
#'   \item{ENSG00000152219}{ARL14EP, log-transformed gene expression level}
#'   \item{ENSG00000100814}{CCNB1IP1, log-transformedgene expression level}
#'   \item{ENSG00000127334}{DYRK2, log-transformed gene expression level}
#'   \item{ENSG00000131355}{ADGRE3, log-transformed gene expression level}
#'   \item{ENSG00000137337}{MDC1, log-transformed gene expression level}
#'   \item{ENSG00000156414}{TDRD9, log-transformed gene expression level}
#'   \item{ENSG00000115085}{ZAP70, log-transformed gene expression level}
#'
#'   ...
#' }
#'
#' @source https://www.medrxiv.org/content/10.1101/2021.05.11.21256877v1
#'
"test_data"
