
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SepstratifieR

<!-- badges: start -->
<!-- badges: end -->

The goal of SepstratifieR is to stratify patients with suspected
infection into groups with different molecular characteristics. This is
done based on the expression level of a small set of genes measured from
whole blood.

License: MIT + file LICENSE

## Installation

You can install the development version of SepstratifieR from
[GitHub](https://github.com/) with:

``` r
# Install dependencies
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
    
BiocManager::install("batchelor")
BiocManager::install("MatrixGenerics")

# Install SepstratifieR
# install.packages("devtools")
devtools::install_github("jknightlab/SepstratifieR")
```

## Details

### Background

This package is designed to stratify patients with suspected infectious
disease into different molecular groups based on a sample of their gene
expression from whole blood. These molecular groups are defined based on
a small gene signature, and are referred to as sepsis response signature
(SRS) groups.

There are three SRS groups, which are as follows:

SRS1 = Composed of sepsis patients with an immunosupressed profile.
These individuals are often at high risk of mortality.

SRS2 = Composed of sepsis patients with an immunocompetent profile.
These individuals are at lower risk of mortality.

SRS3 = Composed mostly of healthy individuals.

For more information on how SRS groups were originally defined, please
refer to the following publications:

<https://doi.org/10.1016/S2213-2600(16)00046-1>

<https://doi.org/10.1164/rccm.201608-1685OC>

### The stratification algorithm

To perform stratification on a group of patient samples (i.e. the user’s
input), SepstratifieR first aligns the input samples to a reference data
set containing gene expression profiles from healthy individuals and
sepsis patients. This alignment is performed using the mutual nearest
neighbours (mNN) algorithm for batch correction. This has the purpose of
bringing the predictor variables to the desired scale.

Next, the samples are classified into SRS groups based on a previously
trained random forest model. In addition, each sample is also assigned a
quantitative sepsis response score (SRSq) based on a second random
forest prediction model. This score (SRSq) goes from 0 to 1. Patients
with SRSq close to zero are likely to be healthy, while patients with
SRSq close to one are at high risk.

The diagram below describes how the models used by SepstratifieR were
built (top panel), as well as how the package’s functions perform
alignment and classification (bottom panel):

![Schematic diagram of the analysis steps performed by the SepstratifieR
package](./man/figures/README-method-diagram.png)

### Input format

The input expected by this function is a data frame object with rows
corresponding to individuals/samples and columns corresponding to genes.
This data frame must contain at least the following columns:

1.  When using the 7-gene signature defined by Davenport et al:

| Column\_name    | Gene\_name |
|:----------------|:-----------|
| ENSG00000152219 | ARL14EP    |
| ENSG00000100814 | CCNB1IP1   |
| ENSG00000127334 | DYRK2      |
| ENSG00000131355 | ADGRE3     |
| ENSG00000137337 | MDC1       |
| ENSG00000156414 | TDRD9      |
| ENSG00000115085 | ZAP70      |

2.  When using the extended 19-gene signature:

| Column\_name    | Gene\_name |
|:----------------|:-----------|
| ENSG00000144659 | SLC25A38   |
| ENSG00000103423 | DNAJA3     |
| ENSG00000135372 | NAT10      |
| ENSG00000079134 | THOC1      |
| ENSG00000135972 | MRPS9      |
| ENSG00000087157 | PGS1       |
| ENSG00000165006 | UBAP1      |
| ENSG00000111667 | USP5       |
| ENSG00000182670 | TTC3       |
| ENSG00000097033 | SH3GLB1    |
| ENSG00000165733 | BMS1       |
| ENSG00000103264 | FBXO31     |
| ENSG00000152219 | ARL14EP    |
| ENSG00000100814 | CCNB1IP1   |
| ENSG00000127334 | DYRK2      |
| ENSG00000131355 | ADGRE3     |
| ENSG00000137337 | MDC1       |
| ENSG00000156414 | TDRD9      |
| ENSG00000115085 | ZAP70      |

If more columns are present, they will simply be ignored.

We recommend that predictor variables have the following units:

**Microarray:** Background-corrected, VSN-normalized, log-transformed
intensity values

**RNA-seq:** Log-transformed counts per million (i.e. log-cpm)

**qRT-PCR:** Negative Cq values

In addition, any technical batch effects should be removedfrom the input
data set before using SepstratifieR.

### A brief example

Below is a basic example which shows you how to use this package to
stratify a small set of patients into sepsis response groups:

``` r
# Load package
library(SepstratifieR)

# Load test data set
data(test_data)
head(test_data)
#>    ENSG00000144659 ENSG00000103423 ENSG00000135372 ENSG00000079134
#> s1        4.692800        4.736014        5.443159        3.828598
#> s2        5.013893        4.413963        5.140826        3.804591
#> s3        4.212220        4.917711        5.154672        3.671660
#> s4        2.938143        3.693315        4.255717        2.470483
#> s5        4.431750        4.718650        5.326826        3.910956
#> s6        3.919289        4.114919        4.461082        3.065047
#>    ENSG00000135972 ENSG00000087157 ENSG00000165006 ENSG00000111667
#> s1        2.977473        7.077379        6.377639        5.561227
#> s2        3.052402        7.193405        6.995388        5.125931
#> s3        3.455646        7.939844        6.848399        5.661574
#> s4        1.642446        9.115725        7.271863        4.215087
#> s5        3.344655        6.972575        6.678864        5.675333
#> s6        2.074246        8.795017        6.937671        5.144748
#>    ENSG00000182670 ENSG00000097033 ENSG00000165733 ENSG00000103264
#> s1        6.648605        7.541566        5.047954        4.928851
#> s2        6.404868        7.199108        4.764898        3.894049
#> s3        6.497354        7.905404        5.142841        4.164078
#> s4        5.576401        8.612519        3.824025        3.425956
#> s5        6.484286        7.718506        4.971902        4.171239
#> s6        5.933122        7.504945        4.194316        3.550335
#>    ENSG00000152219 ENSG00000100814 ENSG00000127334 ENSG00000131355
#> s1        3.765825        2.723711        6.711303        6.461896
#> s2        3.581115        2.723518        6.226455        7.230779
#> s3        3.689515        2.609898        5.410223        5.412017
#> s4        2.648860        1.657687        4.579567        7.341940
#> s5        4.123084        2.629408        6.232329        5.868802
#> s6        2.131015        2.108574        4.714273        6.712530
#>    ENSG00000137337 ENSG00000156414 ENSG00000115085
#> s1        5.136627        3.114777        8.016714
#> s2        4.620764        3.802095        7.002473
#> s3        4.951400        4.585588        6.192307
#> s4        3.986742        6.316707        4.445492
#> s5        4.737964        3.810283        6.879157
#> s6        4.584105        5.820275        6.431018

# Stratify patients
predictions <- stratifyPatients(test_data)
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=20
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> Adding sample names to object...
#> ... done!
```

The results from this prediction look as follows:

``` r
predictions
#> SepsisPrediction
#> 
#> Gene set used:  davenport 
#> 143 samples
#> 7 predictor variables
#> 
#> Predictor variables: ENSG00000152219, ENSG00000100814, ENSG00000127334, ENSG00000131355, ...
#> Sample names: s1, s2, s3, s4, ...
#> SRS: SRS3, SRS3, SRS2, SRS1, ...
#> SRSq: 0.07342065, 0.2410302, 0.3857127, 0.8267178, ...
```

Futhermore, you can use SepstratifieR’s built-in plotting function to
check whether the input samples were successfully mapped to the
reference set and if there are any clear outliers.

``` r
plotAlignedSamples(predictions)
```

<img src="man/figures/README-example_plot-1.png" width="100%" style="display: block; margin: auto;" />

## Using a minimal or an extended gene signature for prediction

SepstratifieR enables predictions based on two different gene
signatures:

1.  A minimal set of 7 genes defined by Davenport et al. in 2016
2.  An extended set of 19 genes defined by Cano-Gamez et al. in 2021.
    This extended set includes the 7 genes proposed by Davenport plus an
    additional 12 genes derived from integrative analysis of RNA-seq and
    microarray data for sepsis patients in the GAinS study.

For further details on the definition of these signatures, please refer
to the relevant publications.

The user can specify which gene signature to use for prediction by
simply assigning a value to the ‘gene\_set’ parameter. The default
behaviour of SepstratifieR is to use the minimal 7-gene signature. This
parameter can be modified as illustrated bellow:

``` r
# Stratify patients based on the 7-gene signature (this is the default option)
predictions <- stratifyPatients(test_data, gene_set = "davenport")
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=20
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> Adding sample names to object...
#> ... done!

# Stratify patients based on the 19-gene signature
predictions_extended <- stratifyPatients(test_data, gene_set = "extended")
#> 
#> Using the 'extended' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=20
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> Adding sample names to object...
#> ... done!
```

IMPORTANT: Note that the extended gene signature was trained using
RNA-seq and microarray measurements only. Thus, in its current state
this signature should not be used to predict labels from qPCR data.

## Setting the number of mutual nearest neighbours (k)

Perhaps the most important parameter to take into account when
performing patient stratification is the number of mutual nearest
neighbours in the data alignment step (k). The impact of this parameter
on data integration has been previously summarized in the documentation
of mNN (<https://rdrr.io/github/LTLA/batchelor/man/mnnCorrect.html>).

In brief, lower values of ‘k’ will retain more substructure in the input
data, with samples that do not closely resemble the reference set being
flagged as outliers (i.e. samples for which no mutual nearest neighbor
was found). Conversely, higher values of ‘k’ will result in a more
lenient and aggressive merging, where samples are forced to align with
the reference data even if they differ in certain aspects. Higher values
of ‘k’ often result in better performance of data integration, but can
also cause outliers to pass undetected, especially when a small group of
samples is not well represented in the reference set.

The authors of mNN suggest that ‘k’ be set to the expected size for the
smallest subpopulation. Based on the proportion of individuals from
different sepsis response (SRS) groups previously reported in the
context of sepsis patients in intensive care, we recommend that this
parameter be set to 20-30% the number of input samples. However, please
not that this value might not be ideal if you are using this algorithm
in a different patient population.

In the section below we explain how to assess if the predictions
obtained with SepstratifieR are robust to the choice of ‘k’.

## Running a sensitivity analysis

It is often unclear which value of ‘k’ is appropriate for a specific
analysis. Moreover, if ‘k’ is low, many samples might be flagged as
potential outliers by SepstratifieR, and it can be difficult to
distinguish whether they are true outliers or simply samples which
remained unmapped in the mNN step.

The best way to tackle both of these problems is by performing a
sensitivity analysis. In this analysis, patient stratification and SRS
prediction are repeatedly performed for a range of ‘k’ values, and the
results from each iteration are compared to each other so as to assess
their stability.

SepstratifieR has a built in function for sensitivity analysis. You can
run this function on the same input used for patient stratification, as
shown below:

``` r
sensitivity_results <- runSensitivityAnalysis(test_data)
#> 
#> Using the ' davenport ' gene signature for prediction...
#> The k parameter will iterate through: 15 29 44 58 72 86 100 115 129 143 
#> Predicting SRSq scores at all k values...
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=15
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> Adding sample names to object...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=29
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> Adding sample names to object...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=44
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> Adding sample names to object...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=58
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> Adding sample names to object...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=72
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> Adding sample names to object...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=86
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> Adding sample names to object...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=100
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> Adding sample names to object...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=115
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> Adding sample names to object...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=129
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> Adding sample names to object...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=143
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> Adding sample names to object...
#> ... done!
#> 
#> Identifying mNN outliers at k=29...
#> Estimating variance in SRSq prediction for different values of k...Plotting SRSq predictions as a function of k...
```

<img src="man/figures/README-sensitivity_analysis_example-1.png" width="100%" style="display: block; margin: auto;" />

    #> Plotting variance in SRSq estimation for each sample...

<img src="man/figures/README-sensitivity_analysis_example-2.png" width="100%" style="display: block; margin: auto;" />

    #> ...done!

The heatmap above clearly shows that the quantitative predictions from
SepstratifieR (SRSq) are robust to the choice of ‘k’, as they do not
seem to change. In addition, when computing the variability in predicted
SRSq scores across all of the evaluated values of ‘k’, we obtain a very
low variance, as shown in the scatter plot. Finally, because samples
flagged as outliers are randomly distributed in the plot and do not show
a higher variance compared to the rest of the data, we can be fairly
confident that they are not true outliers.

Now let’s see how this would look like if a group of outlier samples
were present in the input data.

We begin by artificially increasing the expression levels of ARL14EP for
the last 30 samples in the data set.

``` r
set.seed(1)
test_data$ENSG00000152219[114:143] <- test_data$ENSG00000152219[114:143] + rnorm(30, mean=8, sd=1)

tail(test_data)
#>      ENSG00000144659 ENSG00000103423 ENSG00000135372 ENSG00000079134
#> s138        3.915896        4.142888        4.550090        3.432809
#> s139        3.841592        3.838046        4.299008        3.056424
#> s140        4.224488        4.128654        4.825778        3.525132
#> s141        4.432159        3.845172        4.641201        3.590158
#> s142        4.567482        4.815802        5.530656        3.729049
#> s143        4.363877        4.465925        4.982700        3.860408
#>      ENSG00000135972 ENSG00000087157 ENSG00000165006 ENSG00000111667
#> s138        1.975244        8.415272        7.133359        4.565842
#> s139        2.600997        8.952625        7.380804        4.457593
#> s140        2.780442        8.158555        7.178084        5.036091
#> s141        2.458304        7.974497        6.974679        5.012814
#> s142        3.318740        6.210728        6.288433        5.671912
#> s143        2.690685        7.566938        6.193921        5.038547
#>      ENSG00000182670 ENSG00000097033 ENSG00000165733 ENSG00000103264
#> s138        6.448115        7.868539        4.155435        3.551486
#> s139        5.672482        8.718168        4.180824        3.421137
#> s140        6.035116        8.190729        4.487655        4.006522
#> s141        6.251814        7.602255        4.470171        3.565085
#> s142        6.821453        7.099148        5.150154        4.738323
#> s143        6.526056        7.010125        4.604899        4.163501
#>      ENSG00000152219 ENSG00000100814 ENSG00000127334 ENSG00000131355
#> s138       11.904400        2.369174        5.653310        7.222766
#> s139       11.018487        1.777352        5.199707        6.928787
#> s140       11.695622        2.318047        5.947188        7.787000
#> s141        9.952713        2.409055        5.473638        7.166783
#> s142       11.298369        3.011082        6.455832        6.675081
#> s143       12.389283        2.372734        6.347841        7.299634
#>      ENSG00000137337 ENSG00000156414 ENSG00000115085
#> s138        4.246216        6.541095        6.245411
#> s139        4.141095        5.764071        6.260288
#> s140        4.203260        5.357629        6.673227
#> s141        4.785670        3.899674        5.743222
#> s142        4.840135        2.929434        6.970752
#> s143        4.444932        4.016022        7.484469
```

These samples should now act as a subgruop of outliers and, indeed, they
very clearly separate along PC3.

``` r
preds <- stratifyPatients(test_data, verbose=F)
plotAlignedSamples(preds, pcs=c(1,3), color_by = "mNN_outlier")
```

<img src="man/figures/README-plot_pca_with_outliers-1.png" width="100%" style="display: block; margin: auto;" />

To confirm this, let’s now re-run the sensitivity analysis on this data
set. Notice how now the scatter plot clearly shows that the group of
samples set as outliers has higher variance in their SRSq estimations.
Indeed, most of them are correctly flagged as outliers during mNN
alignment. You can also see this in the heatmap, where the SRSq value
estimated for the outlier samples abruptly decreases as ‘k’ increases.

``` r
sensitivity_results <- runSensitivityAnalysis(test_data)
#> 
#> Using the ' davenport ' gene signature for prediction...
#> The k parameter will iterate through: 15 29 44 58 72 86 100 115 129 143 
#> Predicting SRSq scores at all k values...
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=15
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> Adding sample names to object...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=29
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> Adding sample names to object...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=44
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> Adding sample names to object...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=58
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> Adding sample names to object...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=72
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> Adding sample names to object...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=86
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> Adding sample names to object...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=100
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> Adding sample names to object...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=115
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> Adding sample names to object...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=129
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> Adding sample names to object...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=143
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> Adding sample names to object...
#> ... done!
#> 
#> Identifying mNN outliers at k=29...
#> Estimating variance in SRSq prediction for different values of k...Plotting SRSq predictions as a function of k...
```

<img src="man/figures/README-sensitivity_analysis_with_outliers-1.png" width="100%" style="display: block; margin: auto;" />

    #> Plotting variance in SRSq estimation for each sample...

<img src="man/figures/README-sensitivity_analysis_with_outliers-2.png" width="100%" style="display: block; margin: auto;" />

    #> ...done!

Under this last scenario, the sensitivity analysis suggests we should
exclude at least a subset of the samples flagged as outliers.

## Working with single samples or limited sample sizes

SepstratifieR relies on aligning samples to a reference gene expression
set. This step requires the availability of information from multiple
samples, which is used to identify shared patterns of variation between
batches and achieve a high quality alignment. When dealing with a single
sample, as well as in situations were only a limited number of samples
is available, using the main SepstratifieR’s functions is NOT
recommended. This is because instability in batch alignment makes
predictions unreliable.

Based on simulations and data subsampling, we estimate that the
stratifyPatients() function should only be applied to data sets
containing 25 or more samples.

For situations where sample size is limited, we instead provide a
purpose-built function which uses a ‘lazy learning’ approach to estimate
SRS and SRSq for a given samples. This approach is based on identifying
the samples in our reference set which are most similar to the sample of
interest (i.e. nearest neighbours), and then “projecting” the SRS and
SRSq labels of these nearest neighbours into the sample in question.
Similarity to the reference set is estimated using cosine similarities,
which are independent of scale differences and thus robust to technical
variation. Moreover, projection is based on a “majority vote” system,
where each nearest neighbour contributes information proportionally to
its similarity to the sample of interest.

The following diagram illustrates our lazy learning projection approach:

\[PENDING\]

### Model parameters and input variables

Our lazy learning approach can be performed based on either of the two
gene signatures, as specified by the user. Moreover, the number of
nearest neighbours (k) used to estimate SRS/SRSq from majority voting
can also be specified.

For this function, we recommend that predictor variables have the
following units:

**Microarray:** Background-corrected, VSN-normalized, log-transformed
intensity values

**RNA-seq:** Log-transformed counts per million (i.e. log-cpm)

**qRT-PCR:** 2^(Negative Cq values)

**IMPORTANT NOTES:** 1. The expected units for qRT-PCR data are NOT the
same in stratifyPatients() than in projectPatient(). The latter function
expects positive values (i.e. 2^-Cq). 2. The meaning of ‘k’ in this
function is NOT the same as in stratifyPatients(). The latter uses k for
alignment but not for prediction. For lazy learning, ‘k’ has a direct
impact on prediction.

### A brief example

Below is an example of how to predict SRS/SRSq for a single isolated
sample.

Let’s first choose one random sample from our test set:

``` r
test_sample <- test_data[sample(rownames(test_data),1),]
```

We can stratify this sample by SRS/SRSq by calling the projectPatient()
function within SepstratifieR, as follows:

``` r
# Predict SRS and SRSq using kNN-based label projection
prediction <- projectPatient(test_sample)
#> 
#> Using the 'davenport' gene signature for projection...
#> Fetching predictor variables...
#> 
#> Calculating similarity to reference samples...
#> Projecting SRS/SRS based on nearest neighbours...
#> Number of nearest neighours set to k=20
#> Adding sample names to object...
#> ... done!
```

The resulting object, of class SepsisProjection, contains the SRS and
SRSq values estimated using this approach, as well as metadata on how
the algorithm was run:

``` r
prediction
#> SepsisProjection
#> 
#> Gene set used:  davenport 
#> 7 predictor variables
#> 
#> Predictor variables: ENSG00000152219, ENSG00000100814, ENSG00000127334, ENSG00000131355, ...
#> SRS: SRS2
#> SRSq: 0.6932546
```

Note that this function is not as accurate as stratifyPatients(), since
the latter is based on cross-validated random forest models, for which
accuracy is known and stable. In contrast, projectPatient() is not model
based and is substantially more computationally intensive. Thus, we only
recommend using this approach when less than 25 samples are available.

## Contact

Eddie Cano-Gamez: <ecg@well.ox.ac.uk>
