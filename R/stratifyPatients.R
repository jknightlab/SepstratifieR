#' Assign samples to sepsis response signature groups
#'
#' Given a set of samples, classify them into one of three sepsis response signature (SRS) groups and predict a quantitative
#' sepsis response score (SRSq) for each of them.
#'
#' @param dat A data.frame containing 'n' samples (rows) x 'm' genes (columns). It should contain at least 7 columns, corresponding to the genes listed in the main package documentation.
#' @param k A numeric value specifying the number of nearest neighbours used to align the input to the reference data. Higher values of k will result in a more aggressive integration but can result in missed outliers. In contrast, lower values of k will retain more substructure in the input data, but can result in some samples being incorrectly flagged as outliers. We recommend setting 'k' to a value between 20% and 30% of the total number of input samples. For more information on this paramter, see the general package documentation.
#' @param verbose A logical value indicating whether or not to print a step by step summary of the function's progress.
#'
#' @details
#' This function is designed to stratify patients with suspected infectious disease into different molecular groups based on a sample of their gene expression from whole blood.
#' These molecular groups are defined based on a signature of 7 genes, and are referred to as sepsis response signature (SRS) groups.
#'
#' To perform stratification, the function first aligns the input samples to a reference data set containing gene expression profiles from healthy individuals and sepsis patients. This alignment is performed using the mutual nearest neighbours (mNN) algorithm for batch correction. This has the purpose of bringing the predictor variables to the desired scale.
#' Next, the samples are classified into SRS groups based on a previously trained random forest model. In addition, each sample is also assigned a quantitative sepsis response score (SRSq) based on a second random forest prediction model.
#'
#' The input expected by this function is a data.frame object with rows corresponding to individuals/samples and columns corresponding to genes. This data.frame must contain at least the following seven columns: ENSG00000152219, ENSG00000100814, ENSG00000127334, ENSG00000131355, ENSG00000137337, ENSG00000156414, and ENSG00000115085.
#'
#' We recommend removing any technical batch effects from the input data set before calling this function. In addition, the predictor variables should have a roughly symmetric distribution. Thus, a transformation step is often useful. While this is often not a problem for microarray data sets, we recommend log-transforming any RNA-sequencing and qPCR data before prediction.
#'
#' For more information on how SRS groups were originally defined, please refer to the following publications:
#'
#' https://doi.org/10.1016/S2213-2600(16)00046-1
#' https://doi.org/10.1164/rccm.201608-1685OC
#'
#' @return
#' A SepsisPrediction object containing the SRS and SRSq predictions obtained for each sample.
#'
#' This object contains the following slots:
#'
#' \describe{
#'  \item{SRS}{factor variable indicating the SRS group predicted for each sample, as obtained from random forest prediction.}
#'  \item{SRS_probs}{numeric variable containing the probability of each sample belonging to each SRS group, as obtained from random forest prediction.}
#'  \item{SRSq}{numeric variable indicating the quantitative sepsis response score (SRSq) predicted for each sample, as obtained from random forest prediction. An SRSq close to 0 indicates the individual is likely healthy, an SRSq close to 1 indicates the individual is at high risk of severe sepsis.}
#'  \item{predictors_raw}{data.frame containing the predictor variables as directly extracted from the user's input.}
#'  \item{predictors_transformed}{data.frame containing the predictor variables after mNN-based alignment with the reference set.}
#'  \item{algined_set}{data.frame containing both the user's input data and the reference set, aligned together using mNN.}
#'  \item{mNN_outlier}{logical variable indicating whether each sample is believed to be a potential outlier. Outliers are defined as any samples for which no mutual nearest neighbours were found in the reference set when applying the mNN algorithm.}
#' }
#'
#' @export
#'
#' @examples
#' # Load test data set
#' data(test_data)
#'
#' # Stratify patients
#' predictions <- stratifyPatients(test_data)
#' predictions

stratifyPatients <- function(dat, k=20, verbose=T){

  # Verifying that predictors are present
  if(verbose) {
    cat("Fetching predictor variables...\n")
  }

  if( sum(!colnames(SepstratifieR::reference_set) %in% colnames(dat)) > 0 ) {
    stop(paste("The following variables are missing from the input data set: ",
               dplyr::setdiff(colnames(SepstratifieR::reference_set), colnames(dat)),
               "\n", sep="")
         )
  }

  dat <- dat[,colnames(SepstratifieR::reference_set)]

  # Aligning data to the reference set
  if(verbose) {
    cat("\nAligning data to the reference set...")
    cat("\nNumber of nearest neighours set to k=", k, sep="")
  }

  merged_set <- data.frame(rbind(dat, SepstratifieR::reference_set))
  alignment_batch <- c(rep(2,nrow(dat)),
                       rep(1,nrow(SepstratifieR::reference_set)))
  mnn_res <- batchelor::mnnCorrect(t(merged_set), batch = alignment_batch, merge.order = list(1,2), k=k)

  aligned_set <- data.frame(t(SummarizedExperiment::assay(mnn_res)))
  aligned_dat <- aligned_set[1:nrow(dat),]

  # Identifying potential outliers
  if(verbose) {
    cat("\nIdentifying potential outlier samples...")
  }

  outliers <- !(1:nrow(dat) %in% mnn_res@metadata$merge.info$pairs[[1]]$right)

  # Predicting SRS labels
  if(verbose) {
    cat("\nStratifying samples into sepsis response signature (SRS) groups...")
  }
  SRS_preds <- stats::predict(SRS_model, aligned_dat, type="raw")
  SRS_probs <- stats::predict(SRS_model, aligned_dat, type="prob")

  if(verbose) {
    cat("\nAssigning samples a quantitative sepsis response signature score (SRSq)...")
  }

  SRSq_preds <- stats::predict(SRSq_model, aligned_dat)

  # Returning results
  res <- SepsisPrediction(

    predictors_raw=dat,
    predictors_transformed=aligned_dat,
    aligned_set=aligned_set,
    SRS=SRS_preds,
    SRS_probs=SRS_probs,
    SRSq=SRSq_preds,
    mNN_outlier=outliers

  )

  if(verbose) {
    cat("\n... done!\n\n")
  }

  return(res)

}
