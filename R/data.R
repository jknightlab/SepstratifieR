#' Whole blood gene expression measurements for 7 genes across 3,264 individuals
#'
#' A data set containing gene expression measurements from whole blood for the 7 SRS signature genes defined by Davenport et al.
#'
#' This data set is formed of 1,609 samples from healthy individuals and 1,655 samples from sepsis patients.
#'
#' Sepsis patients were recruited as a part of the Genomic Advances in Sepsis (GAinS) study in Oxford, UK. Of these, 676 were profiled using the Illumina HumanHT microarray, 864 using polyA-based RNA-sequencing, and 115 using qPCR.
#'
#' Healthy individual data was collected from a number of publicly available sources. In particular, 991 OIllumina HumanHT microarray samples were obtained from the SHIP-TREND consortium, 518 Illumina HumanHT microarray samples were obatained from the DILGOM cohort (an extension of the FINRISK study), and 100 polyA-based RNA-sequencing samples were obtained from the dutch 500FG cohort
#'
#' RNA-seq data was log-transformed and any relevant batch effects were removed using the combat algorithm.
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
"reference_set_davenport"

#' Metadata for the 7-gene whole blood gene expression data set
#'
#' A data set containing additional information for the 3,264 samples contained in the reference set.
#'
#' It is formed of 5 variables gathered for 3,264 samples
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
"reference_set_davenport_annotations"

#' Whole blood gene expression measurements for 7 genes across 3,264 samples
#'
#' A data set containing gene expression measurements from whole blood for a signature of 19 genes. This signature comprises the 7 SRS genes defined by Davenport et al plus a further 12 genes identified by Cano-Gamez et al. from microarray and RNA-seq data using canonical correlation analysis.
#'
#' This data set is formed of 1,609 samples from healthy individuals and 1,655 samples from sepsis patients.
#'
#' Sepsis patients were recruited as a part of the Genomic Advances in Sepsis (GAinS) study in Oxford, UK. Of these, 676 were profiled using the Illumina HumanHT microarray, 864 using polyA-based RNA-sequencing, and 115 using qPCR.
#'
#' Healthy individual data was collected from a number of publicly available sources. In particular, 991 OIllumina HumanHT microarray samples were obtained from the SHIP-TREND consortium, 518 Illumina HumanHT microarray samples were obatained from the DILGOM cohort (an extension of the FINRISK study), and 100 polyA-based RNA-sequencing samples were obtained from the dutch 500FG cohort
#'
#' RNA-seq data was log-transformed and any relevant batch effects were removed using the combat algorithm.
#' Finally, the 7 SRS signature genes were extracted from each cohort and the data was integrated together using the mutual nearest neighbout (mNN) algorithm.
#'
#' The values reported in this data set were obtained after mNN alignment, and thus they represent Cosine-scale batch-corrected values.
#'
#'
#' The main use of this data set is to serve as a reference to which new input samples can be aligned before prediction of SRS group using random forest models.
#'
#'
#' @format A data frame with 3264 rows and 19 variables:
#' \describe{
#'   \item{ENSG00000144659}{SLC25A38, cosine-scaled, batch corrected gene expression level}
#'   \item{ENSG00000103423}{DNAJA3, cosine-scaled, batch corrected gene expression level}
#'   \item{ENSG00000135372}{NAT10, cosine-scaled, batch corrected gene expression level}
#'   \item{ENSG00000079134}{THOC1, cosine-scaled, batch corrected gene expression level}
#'   \item{ENSG00000135972}{MRPS9, cosine-scaled, batch corrected gene expression level}
#'   \item{ENSG00000087157}{PGS1, cosine-scaled, batch corrected gene expression level}
#'   \item{ENSG00000165006}{UBAP1, cosine-scaled, batch corrected gene expression level}
#'   \item{ENSG00000111667}{USP5, cosine-scaled, batch corrected gene expression level}
#'   \item{ENSG00000182670}{TTC3, cosine-scaled, batch corrected gene expression level}
#'   \item{ENSG00000097033}{SH3GLB1, cosine-scaled, batch corrected gene expression level}
#'   \item{ENSG00000165733}{BMS1, cosine-scaled, batch corrected gene expression level}
#'   \item{ENSG00000103264}{FBXO31, cosine-scaled, batch corrected gene expression level}
#'   \item{ENSG00000152219}{ARL14EP, cosine-scaled, batch corrected gene expression level}
#'   \item{ENSG00000100814}{CCNB1IP1, cosine-scaled, batch corrected gene expression level}
#'   \item{ENSG00000127334}{DYRK2, cosine-scaled, batch corrected gene expression level}
#'   \item{ENSG00000131355}{ADGRE3, cosine-scaled, batch corrected gene expression level}
#'   \item{ENSG00000137337}{MDC1, cosine-scaled, batch corrected gene expression level}
#'   \item{ENSG00000156414}{TDRD9, cosine-scaled, batch corrected gene expression level}
#'   \item{ENSG00000115085}{ZAP70, cosine-scaled, batch corrected gene expression level}
#'   ...
#' }
#'
"reference_set_extended"

#' Metadata for the 19-gene whole blood gene expression data set
#'
#' A data set containing additional information for the 3,264 samples contained in the reference set.
#'
#' It is formed of 5 variables gathered for 3,264 samples
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
"reference_set_extended_annotations"


#' Whole blood gene expression measurements for 143 samples of COVID-19 patients and healthy volunteers
#'
#' An example data set containing gene expression measurements from whole blood for 19 genes
#'
#' This data set is formed of 149 samples obtained from 79 COVID-19 patients and 10 healthy volunteers from the COMBAT study (https://doi.org/10.5281/zenodo.6120249).
#'
#' The values reported in this data set were obtained by log transformation of raw counts obtained from polyA-based RNA-sequencing.
#'
#' The main use of this data set is to serve as a test set with which to assess the functionality of this package.
#'
#'
#' @format A data frame with 143 rows and 19 variables:
#' \describe{
#'   \item{ENSG00000144659}{SLC25A38, log-transformed gene expression level}
#'   \item{ENSG00000103423}{DNAJA3, log-transformed gene expression level}
#'   \item{ENSG00000135372}{NAT10, log-transformed gene expression level}
#'   \item{ENSG00000079134}{THOC1, log-transformed gene expression level}
#'   \item{ENSG00000135972}{MRPS9, log-transformed gene expression level}
#'   \item{ENSG00000087157}{PGS1, log-transformed gene expression level}
#'   \item{ENSG00000165006}{UBAP1, log-transformed gene expression level}
#'   \item{ENSG00000111667}{USP5, log-transformed gene expression level}
#'   \item{ENSG00000182670}{TTC3, log-transformed gene expression level}
#'   \item{ENSG00000097033}{SH3GLB1, log-transformed gene expression level}
#'   \item{ENSG00000165733}{BMS1, log-transformed gene expression level}
#'   \item{ENSG00000103264}{FBXO31, log-transformed gene expression level}
#'   \item{ENSG00000152219}{ARL14EP, log-transformed gene expression level}
#'   \item{ENSG00000100814}{CCNB1IP1, log-transformed gene expression level}
#'   \item{ENSG00000127334}{DYRK2, log-transformed gene expression level}
#'   \item{ENSG00000131355}{ADGRE3, log-transformed gene expression level}
#'   \item{ENSG00000137337}{MDC1, log-transformed gene expression level}
#'   \item{ENSG00000156414}{TDRD9, log-transformed gene expression level}
#'   \item{ENSG00000115085}{ZAP70, log-transformed gene expression level}
#'   ...
#' }
#'
#'
"test_data"
