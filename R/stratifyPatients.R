stratifyPatients <- function(dat, k=50, verbose=T){

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

  aligned_set <- data.frame(t(assay(mnn_res)))
  aligned_dat <- aligned_set[1:nrow(dat),]

  # Identifying potential outliers
  if(verbose) {
    cat("\nIdentifying potential outlier samples...")
  }

  outliers <- !(1:nrow(dat) %in% mnn_res@metadata$merge.info$pairs[[1]]$right)

  # Predicting labels
  if(verbose) {
    cat("\nStratifying samples into sepsis response signature (SRS) groups...")
  }
  preds <- stats::predict(SepstratifieR::SRS_model, aligned_dat, type="raw")
  pred_probs <- stats::predict(SepstratifieR::SRS_model, aligned_dat, type="prob")

  if(verbose) {
    cat("\nAssigning samples a qunatitative sepsis response signature score (SRSq)...")
  }

  preds_TRS <- stats::predict(SepstratifieR::SRSq_model, aligned_dat)

  res <- list(
    raw_predictors = dat,
    aligned_predictors = aligned_dat,
    aligned_set = aligned_set,
    SRS_predictions = preds,
    SRS_prediction_probs = pred_probs,
    SRSq_predictions = preds_TRS,
    is_outlier = outliers
  )

  if(verbose) {
    cat("\n... done!\n")
  }

  return(res)

}
