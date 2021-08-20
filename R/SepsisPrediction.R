# Defining SepsisPrediction class
setClass("SepsisPrediction",
         slots=list(predictors_raw="data.frame",
                    predictors_transformed = "data.frame",
                    aligned_set = "data.frame",
                    SRS = "factor",
                    SRS_probs = "data.frame",
                    SRSq = "numeric",
                    is_outlier = "logical")
)

# Defining methods associated with the SepsisPrediction class
setMethod("show",
          "SepsisPrediction",
          function(object) {
            cat("SepsisPrediction\n\n")
            cat(nrow(object@predictors_raw)," samples\n", sep="")
            cat(ncol(object@predictors_raw)," predictor variables\n\n", sep="")
            if(nrow(object@predictors_raw) > 0) {
              cat("Predictor variables: ")
              cat(utils::head(rownames((object@predictors_raw)), n=4),"...\n", sep=", ")
              cat("Sample names: ")
              cat(utils::head(colnames((object@predictors_raw)), n=4),"...\n", sep=", ")
              cat("SRS: ")
              cat(utils::head(as.character(object@SRS), n=4),"...\n", sep=", ")
              cat("SRSq: ")
              cat(utils::head(object@SRSq, n=4),"...\n", sep=", ")
            }
          }
)

# Creating a constructor SepsisPrediction method
SepsisPrediction <- function(predictors_raw=NULL, predictors_transformed=NULL, aligned_set=NULL, SRS=NULL, SRS_probs=NULL, SRSq=NULL, is_outlier=NULL) {

  methods::new(
    "SepsisPrediction",
    predictors_raw = data.frame(predictors_raw),
    predictors_transformed = data.frame(predictors_transformed),
    aligned_set = data.frame(aligned_set),
    SRS = factor(SRS),
    SRS_probs = data.frame(SRS_probs),
    SRSq = as.numeric(SRSq),
    is_outlier = as.logical(is_outlier)
  )

}
