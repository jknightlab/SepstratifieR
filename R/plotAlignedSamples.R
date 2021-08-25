#' Visualise how input samples align to the reference set using PCA
#'
#' @param preds A sepsisPrediction object containing the output from the stratifyPatients() function
#' @param color_by Variable by which data points should be coloured. Must be one of the following: "SRS", "SRSq", and "mNN_outlier"
#'
#' @details
#' This function can be used to check whether a set of input samples was successfullt mapped to the reference set.
#'
#' When called, this function performs principal component analysis on the aligned data (i.e. an integrated set containing both the user's input and the reference samples).
#' Next, the first two principal components are plotted. Reference samples are plotted in the background with low transparency, with the user's input samples as darker points in the foreground.
#' The user can specify which variable to color the data points by. Three options are available: "SRS", "SRSq" and "mNN_outlier" This last ooption is useful when assessing if a subset of samples flagged as outliers should be excluded.
#'
#' @return A plot showing the distribution of input and reference samples in PCA space. This plot is a ggplot object.
#' @export
#'
#' @examples
#' # Load test data set
#' data(test_data)
#'
#' # Stratify patients
#' predictions <- stratifyPatients(test_data)
#'
#' # Plot alignment results
#' plotAlignedSamples(predictions)


plotAlignedSamples <- function(preds, color_by="SRS") {
  if(!color_by %in% c("SRS","SRSq","mNN_outlier")) {
    stop("Invalid 'color_by' option. Please chose a valid option among: SRS, SRSq, or mNN_outlier")
  }

  # Creating annotation table
  pred_annotations <- data.frame(
    Study = rep("Input", nrow(preds@predictors_raw)),
    Assay = rep("Input", nrow(preds@predictors_raw)),
    SRS = preds@SRS,
    SRSq = preds@SRSq,
    mNN_outlier = preds@mNN_outlier
  )

  annotations <- rbind(pred_annotations, reference_set_annotations)

  # Performing PCA
  pca_res <- stats::prcomp(preds@aligned_set)
  pca_var <- round(pca_res$sdev^2/sum(pca_res$sdev^2)*100,0)

  pca_coords <- data.frame(pca_res$x)
  pca_coords <- cbind(pca_coords, annotations)

  # Plotting PCA
  if(color_by == "SRS") {
    return(
      ggplot2::ggplot(pca_coords[pca_coords$Study != "Input", ], ggplot2::aes(x=PC1, y=PC2)) +
        ggplot2::geom_point(ggplot2::aes(color=SRS), alpha=0.2, size=0.7) +
        ggplot2::scale_color_manual(values=c("darkred","steelblue","darkblue")) +
        ggplot2::geom_point(data=pca_coords[pca_coords$Study == "Input", ], ggplot2::aes(color=SRS), size=2) +
        ggplot2::xlab(paste("PC1: ", pca_var[1], "% of variance explained", sep="")) +
        ggplot2::ylab(paste("PC2: ", pca_var[2], "% of variance explained", sep="")) +
        ggplot2::theme_classic()
    )
  }

  if(color_by == "SRSq") {
    return(
      ggplot2::ggplot(pca_coords[pca_coords$Study != "Input", ], ggplot2::aes(x=PC1, y=PC2)) +
        ggplot2::geom_point(ggplot2::aes(color=SRSq), alpha=0.2, size=0.7) +
        ggplot2::scale_color_gradient(low = "lightgrey", high = "darkblue") +
        ggplot2::geom_point(data=pca_coords[pca_coords$Study == "Input", ], ggplot2::aes(color=SRSq), size=2) +
        ggplot2::theme_classic()
    )
  }

  if(color_by == "mNN_outlier") {
    return(
      ggplot2::ggplot(pca_coords[pca_coords$Study != "Input", ], ggplot2::aes(x=PC1, y=PC2)) +
        ggplot2::geom_point(color="lightgrey", alpha=0.5, size=0.7) +
        ggplot2::geom_point(data=pca_coords[pca_coords$Study == "Input", ], ggplot2::aes(color=mNN_outlier), size=2) +
        ggplot2::scale_color_manual(values=c("black","red")) +
        ggplot2::theme_classic()
    )
  }

}
