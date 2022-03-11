#' Calculate the cosine similarity between two numeric vectors
#'
#' @param d1 First numeric vector
#' @param d2 Second numeric vector (must be the same length as d1)
#'
#' @details
#' This function calculates the cosine similarity between a pair of vectors.
#'
#' Cosine similarities are a measure of similarity between two series of numbers. They are mathematically defined as the cosine of the angle between both vectors.
#' Cosine similarities are bound between -1 and 1, with −1 indicating exactly opposite directions and 1 indicating identical directions. Values of 0 indicate the vectors are orthogonal.
#'
#' @return A numeric vector of cosine similarities.
#' @export
#'
#' @examples
#' # Create two correlated vectors
#' d1 <- rnorm(10,1)
#' d2 <- d1 + rnorm(10,1,0.5)
#'
#' # Calculate the cosine similarity between them
#' cosineSimilarity(d1,d2)
#'

cosineSimilarity <- function(d1,d2){
  sum(d1*d2)/(sqrt(sum(d1^2))*sqrt(sum(d2^2)))
}
