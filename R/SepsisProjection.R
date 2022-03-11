# Defining SepsisProjection class
setClass("SepsisProjection",
         slots=list(gene_set="character",
                    predictors="numeric",
                    cosine_similarities = "data.frame",
                    SRS = "factor",
                    SRS_probs = "data.frame",
                    SRSq = "numeric")
         )

# Defining methods associated with the SepsisProjection class
setMethod("show",
          "SepsisProjection",
          function(object) {
            cat("SepsisProjection\n\n")
            cat("Gene set used: ", object@gene_set, "\n")
            cat(length(object@predictors)," predictor variables\n\n", sep="")
            if(length(object@predictors) > 0) {
              cat("Predictor variables: ")
              cat(utils::head(names(object@predictors), n=4),"...", sep=", ")
              cat("\nSRS: ")
              cat(as.character(object@SRS))
              cat("\nSRSq: ")
              cat(as.numeric(object@SRSq))
              cat("\n")
            }
          }
)

# Creating a constructor SepsisProjection method
SepsisProjection <- function(gene_set=NULL, predictors=NULL, cosine_similarities=NULL, SRS=NULL, SRS_probs=NULL, SRSq=NULL) {

  methods::new(
    "SepsisProjection",
    gene_set = as.character(gene_set),
    predictors = as.numeric(predictors),
    cosine_similarities = data.frame(cosine_similarities),
    SRS = factor(SRS),
    SRS_probs = data.frame(SRS_probs),
    SRSq = as.numeric(SRSq)
  )

}
