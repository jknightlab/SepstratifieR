#' Perform a sensitivity analysis to asssess the impact of 'k' on patient stratification
#'
#' @param dat A data.frame containing 'n' samples (rows) x 'm' genes (columns). It should contain at least 7 columns, corresponding to the genes listed in the main package documentation.
#' @param gene_set A character value specifying which gene signature to use for stratification. This must be one of two values: 'davenport' (uses the 7-gene signature described by Davenport et al.) or 'extended' (uses an extended 19 gene-signature).
#' @param plot A logical value indicating whether or not to plot the visualisations obtained from sensitivity analysis. A working version of ggplot is needed for this functionality.
#' @param verbose A logical value indicating whether or not to print a step by step summary of the function's progress.
#'
#' @details
#' Choosing different values of 'k' for the mutual nearest neighbours (mNN) alignment step can change the way the input data is aligned to the reference. In particular, low 'k' values can result in too many samples flagged as outliers, even when they are not. In contrast, high 'k' values can force data integration, causing outliers to pass unnoticed.
#' This function is designed to test whether the predictions obtained with SepstratifieR are robust to the choice of 'k'. This is done by repeatedly performing data alignment and patient stratification at different values of 'k' and comparing the results obtained at each iteration.
#'
#' To perform sensitivity analysis, this function first defines a list of values though which 'k' will iterate. These values are set to go from 10% to 100% of the data, with an increment of 10% at each step.
#' The stratifyPatients() function is then run for each value of 'k' and the resulting SRSq predictions are compiled. These are in turn presented to the user in the form of a few easy to interpret visualizations.
#'
#' When run in plotting mode (i.e. with the plotting parameter set to plot=T), this function will generate the following two visualizations:
#'
#' 1. A heatmap showing the value of SRSq predicted for each sample (rows) at increasingly larger values of 'k' (columns). Furthermore, an indicator colum shows which samples were flagged as potential mNN outliers.
#'
#' 2. A scatter plot of SRSq variance. This plot shows how much the SRSq prediction changes for each sample when computed using values of 'k' Each sample is colored according to whether or not it was flagged as a potential outlier.
#'
#'
#' In the absence of true outliers, the SRSq values inferred for each sample should be robust and stable. This can be seen in the heatmap as rows having a constant color across the full range of 'ks'. Furthermore, samples should show a low variance in the scatter plot, with any samples flagged as potential outliers being randomly distributed.
#' In contrast, in the presence of a group of outliers,the SRSq predictions for these samples should be unstable and sensitive to the choice of 'k'. This can be seen in the heatmap as rows which abruptly change color as the value of 'k' increases. Furthermore, the scatter plot should show a subset of samples (i.e. the outliers) with higher variance than the rest. These should ideally be enriched in samples flagged as potential mNN outliers.
#'
#' @return
#' #' A list containing the SRSq predictions obtained for each sample at different values of k, as well as the corresponding variance estimations.
#'
#' This list contains the following slots:
#'
#' \describe{
#'  \item{SRSq_estimates}{A data frame containing the sepsis signature respnose score (SRSq) estimated for each sample (rows) at each value of 'k' (columns).}
#'  \item{SRSq_variances}{A data frame containing the variance in SRSq prediction for each sample across all 'k' values. An indicator column (mnn_outlier) is also included so as to identify the samples marked as potential outliers in the mNN alignment step.}
#' }
#'
#' @export
#'
#' @examples
#' # Load test data set
#' data(test_data)
#'
#' # Run sensitivity analysis
#' runSensitivityAnalysis(test_data)
#'

runSensitivityAnalysis <- function(dat, gene_set="davenport", plot=T, verbose=T) {

  # Verifying that requested gene set matches function options
  if(!gene_set %in% c("davenport", "extended")) {
    stop("The gene set specified is not valid. Please select one of the following: 'davenport', 'extended'\n")
  }

  # Defining predictor variables for the gene set of choice
  if(verbose) {
    cat("\nUsing the '", gene_set, "' gene signature for prediction...\n")
  }

  ks <- round(stats::quantile(1:nrow(dat),  probs = seq(0.1, 1, by = 0.1)))
  if(verbose) {
    cat("The k parameter will iterate through:", ks,"\n", sep=" ")
  }

  if(verbose) {
    cat("Predicting SRSq scores at all k values...\n\n")
  }
  preds_SRSq <- data.frame(
    sapply(ks, function(k){
      res <- SepstratifieR::stratifyPatients(dat, gene_set, k, verbose=verbose)
      return(res@SRSq)
    }),
    row.names = rownames(dat))
  colnames(preds_SRSq) <- paste("k",ks,sep="_")

  if(verbose) {
    cat("Identifying mNN outliers at k=", ks[2], "...\n", sep="")
  }
  mnn_outliers <- SepstratifieR::stratifyPatients(dat, k=ks[2], verbose=F)@mNN_outlier

  if(verbose) {
    cat("Estimating variance in SRSq prediction for different values of k...")
  }
  SRSq_vars <- data.frame(
    sample_index = 1:nrow(dat),
    variance = MatrixGenerics::rowVars(as.matrix(preds_SRSq)),
    mnn_outlier = mnn_outliers,
    row.names = rownames(preds_SRSq)
  )

  if(plot) {

    if(verbose) {
      cat("Plotting SRSq predictions as a function of k...\n")
    }
    row_anns <- data.frame(mNN_outlier=as.factor(mnn_outliers),
                           row.names = rownames(preds_SRSq))
    print(
      pheatmap::pheatmap(preds_SRSq,
                         scale = "none",
                         color = grDevices::colorRampPalette(c("darkblue","lightgrey","darkred"))(100),
                         annotation_row = row_anns,
                         cluster_cols = F,
                         show_rownames = F,
                         cellwidth = 20)
    )
  }

  if(plot) {
    if(verbose) {
      cat("Plotting variance in SRSq estimation for each sample...\n")
    }


    print(
      ggplot2::ggplot(SRSq_vars, ggplot2::aes(x=sample_index, y=variance)) +
        ggplot2::geom_point(ggplot2::aes(color=mnn_outlier)) +
        ggplot2::theme_classic()
    )

    if(verbose) {
      cat("...done!\n")
    }
  }

  sensitivity_output <- list(SRSq_estimates=preds_SRSq, SRSq_variances=SRSq_vars)
  return(sensitivity_output)

}
