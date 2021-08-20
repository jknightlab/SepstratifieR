#' Assign samples to sepsis response signature groups
#'
#' Given a set of samples for which the seven signature genes were measured, classify
#' the samples into one of three sepsis reponse signature (SRS) groups and predict a quantitative
#' sepsis response score (SRSq) for each of them.
#'
#' @param dat A data.frame containing n samples (rows) and 7 genes (columns). This data.frame must include all of the following columns: ENSG00000152219, ENSG00000100814, ENSG00000127334, ENSG00000131355, ENSG00000137337, ENSG00000156414, and ENSG00000115085
#' @param k A numeric value specifying the number of nearest neighbours used to align the input to the reference data. This parameter is used for mutual nearest neighbours alignment with mnnCorrect().
#' @param verbose A logical value indicating whether or not to print a step by step summary of the function's progress.
#'
#' @return
#' A SepsisPrediction object containing the SRS and SRSq predictions for each sample, an indicator variable flagging potential outlier samples, and the predictor genes before and after mNN alignment.
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
    cat("\nFetching predictor variables...\n")
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
    cat("\nAssigning samples a qunatitative sepsis response signature score (SRSq)...")
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
    is_outlier=outliers

  )

  if(verbose) {
    cat("\n... done!\n\n")
  }

  return(res)

}
