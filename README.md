
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SepstratifieR

<!-- badges: start -->
<!-- badges: end -->

The goal of SepstratifieR is to stratifying patients with suspected
infection into groups with different molecular characteristics. This is
done based on the expression level of 7 genes measured from whole blood.

License: MIT + file LICENSE

## Installation

You can install the development version of SepstratifieR from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("jknightlab/SepstratifieR")
```

## Example

This is a basic example which shows you how to use this package to
stratify a small set of patients into sepsis reponse groups:

``` r
# Load package
library(SepstratifieR)

# Load test data set
data(test_data)

# Stratify patients
predictions <- stratifyPatients(test_data)
#> 
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=20
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a qunatitative sepsis response signature score (SRSq)...
#> ... done!
```

``` r
predictions
#> SepsisPrediction
#> 
#> 25 samples
#> 7 predictor variables
#> 
#> Predictor variables: S1, S2, S3, S4, ...
#> Sample names: ENSG00000152219, ENSG00000100814, ENSG00000127334, ENSG00000131355, ...
#> SRS: SRS3, SRS3, SRS1, SRS3, ...
#> SRSq: 0.07322879, 0.1849735, 0.8394905, 0.08564241, ...
```
