stratifyPatients <- function(dat, k=50){

  # Verifying that predictors are present
  if( sum(!model_rf$coefnames %in% colnames(dat)) > 0 ) {
    cat("\nERROR: Some predictors are missing. Make sure the input matrix contains the following columns:\n")
    cat(model_rf$coefnames)
    cat("\n")
    stop()
  }
  dat <- dat[,model_rf$coefnames]

  # Aligning data to the reference set
  merged_set <- data.frame(rbind(dat, SepstratifieR::reference_set))
  alignment_batch <- c(rep(2,nrow(dat)),
                       rep(1,nrow(SepstratifieR::reference_set)))
  mnn_res <- batchelor::mnnCorrect(t(merged_set), batch = alignment_batch, merge.order = list(1,2), k=k)
  aligned_set <- data.frame(t(assay(mnn_res)))
  aligned_dat <- aligned_set[1:nrow(dat),]

  # Identifying potential outliers
  outliers <- !(1:nrow(dat) %in% mnn_res@metadata$merge.info$pairs[[1]]$right)

  # Predicting labels
  preds <- stats::predict(model_rf, aligned_dat, type="raw")
  pred_probs <- stats::predict(model_rf, aligned_dat, type="prob")
  preds_TRS <- stats::predict(model_rf_TRS, aligned_dat)

  res <- list(
    raw_predictors = dat,
    aligned_predictors = aligned_dat,
    aligned_set = aligned_set,
    predictions = preds,
    prediction_probs = pred_probs,
    predicted_TRS = preds_TRS,
    potential_outlier = outliers
  )

  return(res)

}
