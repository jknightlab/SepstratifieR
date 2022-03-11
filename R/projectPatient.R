#' Estimate SRS/SRSq for a single sample by projecting it to a reference set
#'
#' Classify a sample into one of three sepsis response signature (SRS) groups and predict a quantitative sepsis response signature (SRSq) score it.
#' Prediction is achieved by projecting the sample to a reference gene expression set and assigning SRS/SRSq based on the k nearest neighbours.
#'
#' @param dat A numeric variable containing 'm' gene expression measurements. This variable must contain names, corresponding to Ensembl gene ids. It should contain at least 7 values, corresponding to the genes listed in the main package documentation.
#' @param gene_set A character value specifying which gene signature to use for stratification. This must be one of two values: 'davenport' (uses the 7-gene signature described by Davenport et al.) or 'extended' (uses an extended 19 gene-signature).
#' @param k A numeric value specifying the number of nearest neighbours used to derive SRS and SRSq for the sample in question. Note: This parameter is not the same as 'k' in the stratifyPatients() function.
#' @param verbose A logical value indicating whether or not to print a step by step summary of the function's progress.
#'
#' @details
#' This function is designed to derive SRS labels and SRSq scores for a single, isolated sample from a patient with suspected infection.
#' These molecular groups are defined based on either a 7-gene signature or a 19-gene signature, and are referred to as sepsis response signature (SRS) groups.
#'
#' This function is designed specifically for situations where the sample size is too low for using the alignment approach in the stratifyPatients() function.
#'
#'
#' To perform stratification, this function relies on a "lazy learning", k-nearest neighbours based classification approach.

#' Firstly, the function calculate cosine similarities between the sample of interest and each of the samples in the reference set. This calculation is based on the 7 o 19 genes inputed by the user. Cosine similarities represent the cosine of the angle between two vectors, and can measure how similar two lists of numbers are robustly, regardless of differences in scale.
#' Next, 'k' reference samples with highest cosine similarity to the sample of interest are defined as its nearest neighbours. 'k' can be set by the user.
#' A majority voting approach is then used to assign SRS and SRSq. In brief, SRS is set to the value shown by the majority of the nearest neighbours, where the contribution of each neighbour is weighted by its cosine similarity to the sample of interest.
#' Similarly, SRSq is defined as the weighted average of the SRSq scores of all the nearest neighbours, where the value of each neighbour is weighted by its cosine similarity ot the sample of interest.
#'
#' The input expected by this function is a numeric object with rows gene expression measurements for a single sample. Each numeric value must be named with its corresponding gene ID (i.e. Ensemnbl ID). This object must contain at least the following seven genes: ENSG00000152219, ENSG00000100814, ENSG00000127334, ENSG00000131355, ENSG00000137337, ENSG00000156414, and ENSG00000115085.
#'
#' We recommend using this function when the sample size is low (< 25 samples). For larger sample sizes, the stratifyPatients() function is recommended, since it is based on cross-validated random forest models and should yield more accurate predictions.
#'
#' For more information on how SRS groups were originally defined, please refer to the following publications:
#'
#' https://doi.org/10.1016/S2213-2600(16)00046-1
#' https://doi.org/10.1164/rccm.201608-1685OC
#'
#' @return
#' A SepsisProjection object containing the SRS and SRSq projections for the sample of interest.
#'
#' This object contains the following slots:
#'
#' \describe{
#'  \item{SRS}{factor variable indicating the SRS group projected to this sample}
#'  \item{SRS_probs}{numeric variable containing estimates of the probability of this sample belonging to each SRS class, as obtained from kNN weighted cosine similarities.}
#'  \item{SRSq}{numeric variable indicating the quantitative sepsis response score (SRSq) projected for this sample. An SRSq close to 0 indicates the individual is likely healthy, an SRSq close to 1 indicates the individual is at high risk of severe sepsis.}
#'  \item{predictors}{numeric vriable containing the gene expression values used to predict SRS/SRSq, as inputed by the user.}
#'  \item{cosine_similarities}{data.frame containing both the estimated cosine similarities between the input sample and each sample in the reference set.}
#'  \item{gene_set}{character variable indicating which gene signature was used for prediction (either the Davenport or the Extended signature)}
#' }
#'
#' @export
#'
#' @examples
#' # Load test data set
#' data(test_data)
#'
#' # Project SRS/SRSq using the signature originally described by Davenport et al.
#' sample_of_interest <- sample(rownames(test_data),1)
#' predictions <- projectPatient(test_data[sample_of_interest,])
#' predictions
#'
#' # Project SRS/SRSq using an extended 19-gene signature
#' predictions <- projectPatient(test_data[sample_of_interest,], gene_set="extended")
#' predictions

projectPatient <- function(dat, gene_set="davenport", k=20, verbose=T){

  # Verifying that requested gene set matches function options
  if(!gene_set %in% c("davenport", "extended")) {
    stop("Invalid 'gene_set' option. Please select one of the following: 'davenport', 'extended'\n")
  }

  # Defining predictor variables for the gene set of choice
  if(verbose) {
    cat("\nUsing the '", gene_set, "' gene signature for projection...\n", sep="")
  }

  if(gene_set == "davenport") {
    reference_set <- SepstratifieR::reference_set_davenport
    reference_annotations <- SepstratifieR::reference_set_davenport_annotations
  }
  if(gene_set == "extended") {
    reference_set <- SepstratifieR::reference_set_extended
    reference_annotations <- SepstratifieR::reference_set_extended_annotations
  }

  # Verifying that predictors are present
  if(verbose) {
    cat("Fetching predictor variables...\n")
  }

  if( sum(!colnames(reference_set) %in% names(dat)) > 0 ) {
    stop(paste("The following variables are missing from the input data set: \n",
               dplyr::setdiff(colnames(reference_set), names(dat)),
               "\n",
               sep="")
    )
  }

  dat <- dat[colnames(reference_set)]

  # Calculating cosine similarities
  if(verbose) {
    cat("\nCalculating similarity to reference samples...")
  }

  cosine_similarities <- sapply(1:nrow(reference_set), FUN=function(i){
    similarity <- cosineSimilarity(dat, reference_set[i,])
  })

  cosine_similarities <- data.frame(
    cosine_similarity=cosine_similarities,
    SRS=reference_annotations$SRS,
    SRSq=reference_annotations$SRSq,
    row.names = rownames(reference_set)
  )

  cosine_similarities <- cosine_similarities[order(-cosine_similarities$cosine_similarity),]

  # Projecting samples to reference
  if(verbose) {
    cat("\nProjecting SRS/SRS based on nearest neighbours...")
    cat("\nNumber of nearest neighours set to k=", k, sep="")
  }

  kNNs <- cosine_similarities[1:k,]
  kNN_weights <- kNNs$cosine_similarity/sum(kNNs$cosine_similarity)

  ## SRS assignment
  SRS_probs <- c(SRS1=sum(kNN_weights[kNNs$SRS=="SRS1"]),
                 SRS2=sum(kNN_weights[kNNs$SRS=="SRS2"]),
                 SRS3=sum(kNN_weights[kNNs$SRS=="SRS3"]))
  SRS <- names(SRS_probs[which.max(SRS_probs)])

  ## SRSq assignment
  SRSq <- sum(kNNs$SRSq*kNN_weights)

  # Returning results
  res <- SepsisProjection(

    gene_set=gene_set,
    predictors=dat,
    cosine_similarities=cosine_similarities,
    SRS=SRS,
    SRS_probs=SRS_probs,
    SRSq=SRSq

  )

  # Adding sample names to predictions
  if(verbose) {
    cat("\nAdding sample names to object...")
  }
  names(res@predictors) <- names(dat)

  if(verbose) {
    cat("\n... done!\n\n")
  }

  return(res)

}
