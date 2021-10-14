
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

ENSG00000152219, ENSG00000100814, ENSG00000127334, ENSG00000131355,
ENSG00000137337, ENSG00000156414, and ENSG00000115085.

2.  When using the extended 19-gene signature:

ENSG00000144659, ENSG00000103423, ENSG00000135372, ENSG00000079134,
ENSG00000135972, ENSG00000087157, ENSG00000165006, ENSG00000111667,
ENSG00000182670, ENSG00000097033, ENSG00000165733, ENSG00000103264,
ENSG00000152219, ENSG00000100814, ENSG00000127334, ENSG00000131355,
ENSG00000137337, ENSG00000156414, and ENSG00000115085.

If more columns are present, they will simply be ignored.

We recommend that predictor variables have the following units:

Microarray = Background-corrected, VSN-normalized, log-transformed
intensity values

RNA-seq = Log-transformed counts per million (i.e. log-cpm)

qPCR = log-transformed relative expression values (i.e. this is
equivalent to negative Cq values)

In addition, we recommend removing any technical batch effects from the
input data set before using SepstratifieR.

## A brief example

Below is a basic example which shows you how to use this package to
stratify a small set of patients into sepsis reponse groups:

``` r
# Load package
library(SepstratifieR)

# Load test data set
data(test_data)
head(test_data)
#>    ENSG00000144659 ENSG00000103423 ENSG00000135372 ENSG00000079134
#> s1        2.673567        3.236907        3.574778        2.708307
#> s2        2.552632        3.394534        3.072023        2.656014
#> s3        4.331399        4.569400        4.474664        4.071879
#> s4        3.076774        3.637850        3.870475        3.334008
#> s5        3.085142        3.680973        3.596578        3.101938
#> s6        3.137340        3.888312        4.003193        3.568940
#>    ENSG00000135972 ENSG00000087157 ENSG00000165006 ENSG00000111667
#> s1        2.378041        8.936893        8.121977        4.188131
#> s2        1.978933        8.557574        7.626752        3.840953
#> s3        3.603559        6.096896        5.659749        5.298082
#> s4        2.608770        7.711050        7.192709        4.907146
#> s5        2.398672        8.060679        7.312355        4.164068
#> s6        2.587801        7.967144        7.021835        4.475674
#>    ENSG00000182670 ENSG00000097033 ENSG00000165733 ENSG00000103264
#> s1        4.892583        9.068650        3.377368        2.630745
#> s2        4.466144        8.565756        2.783253        3.084432
#> s3        5.789816        6.553623        4.161501        3.961423
#> s4        5.060853        8.483341        3.686282        3.231659
#> s5        4.872291        8.500375        3.576689        2.520279
#> s6        5.153679        8.616115        3.900714        3.318352
#>    ENSG00000152219 ENSG00000100814 ENSG00000127334 ENSG00000131355
#> s1        3.333535        1.639094        4.335412        3.428269
#> s2        2.886067        1.748837        3.973618        5.987232
#> s3        3.772378        3.237889        4.544628        5.734668
#> s4        3.418864        2.639844        4.240509        7.160660
#> s5        2.285600        1.993234        3.451226        7.538943
#> s6        3.376342        2.179106        4.651830        6.621307
#>    ENSG00000137337 ENSG00000156414 ENSG00000115085
#> s1        3.473401        7.595030        5.375783
#> s2        2.900175        7.730813        5.320940
#> s3        3.426866        3.161742        7.531077
#> s4        3.085830        5.814416        5.944556
#> s5        3.134954        4.493871        4.891739
#> s6        3.531146        6.900173        5.872454

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
#> ... done!
```

The results from this prediction look as follows:

``` r
predictions
#> SepsisPrediction
#> 
#> Gene set used:  davenport  gene set
#> 150 samples
#> 7 predictor variables
#> 
#> Predictor variables: ENSG00000152219, ENSG00000100814, ENSG00000127334, ENSG00000131355, ...
#> Sample names: s1, s2, s3, s4, ...
#> SRS: SRS1, SRS1, SRS3, SRS2, ...
#> SRSq: 0.8317026, 0.8871088, 0.1440521, 0.6774954, ...
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
parameter can be modififed as illustrated bellow:

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
#> The k parameter will iterate through: 16 31 46 61 76 90 105 120 135 150 
#> Predicting SRSq scores at all k values...
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=16
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=31
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=46
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=61
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=76
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=90
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=105
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=120
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=135
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=150
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> ... done!
#> 
#> Identifying mNN outliers at k=31...
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
test_data$ENSG00000152219[121:150] <- test_data$ENSG00000152219[121:150] + rnorm(30, mean=8, sd=1)

tail(test_data)
#>      ENSG00000144659 ENSG00000103423 ENSG00000135372 ENSG00000079134
#> s145        3.671828        3.625883        3.707559        3.436591
#> s146        3.495398        4.306410        3.853202        3.628831
#> s147        4.221127        3.883138        4.075091        3.424667
#> s148        3.430073        4.308963        4.212526        3.798186
#> s149        2.952592        3.588329        3.789029        3.365419
#> s150        3.207951        4.085319        4.177532        3.300825
#>      ENSG00000135972 ENSG00000087157 ENSG00000165006 ENSG00000111667
#> s145        3.365678        7.965301        6.595675        5.656945
#> s146        2.777025        7.567918        7.194763        4.438655
#> s147        2.926692        8.262188        7.064954        4.687693
#> s148        2.912047        6.581501        6.571095        4.794324
#> s149        2.432039        7.744270        7.197536        4.439654
#> s150        2.690963        7.667885        7.488754        4.742504
#>      ENSG00000182670 ENSG00000097033 ENSG00000165733 ENSG00000103264
#> s145        5.466750        7.431763        3.409727        3.478558
#> s146        5.583912        8.232017        3.884039        3.233317
#> s147        4.760768        8.204865        3.964135        3.130939
#> s148        5.849326        8.036181        4.391221        3.138895
#> s149        5.299999        8.467335        3.681907        3.156041
#> s150        5.337387        8.356813        3.956901        3.300825
#>      ENSG00000152219 ENSG00000100814 ENSG00000127334 ENSG00000131355
#> s145        11.85694        2.483887        3.499093        6.043421
#> s146        11.43260        2.439172        4.912446        7.583854
#> s147        11.34453        2.068779        4.585339        7.544762
#> s148        10.20149        2.510794        4.590554        7.245859
#> s149        11.02417        2.198658        5.147294        7.933451
#> s150        11.90699        2.435448        4.449821        7.164623
#>      ENSG00000137337 ENSG00000156414 ENSG00000115085
#> s145        1.658643        4.493903        7.198202
#> s146        3.994141        6.420672        6.386530
#> s147        3.069508        4.296791        5.638428
#> s148        4.169409        3.426893        5.763056
#> s149        3.019305        4.034564        6.155998
#> s150        3.525733        7.245536        5.926355
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
#> The k parameter will iterate through: 16 31 46 61 76 90 105 120 135 150 
#> Predicting SRSq scores at all k values...
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=16
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=31
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=46
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=61
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=76
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=90
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=105
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=120
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=135
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> ... done!
#> 
#> 
#> Using the 'davenport' gene signature for prediction...
#> Fetching predictor variables...
#> 
#> Aligning data to the reference set...
#> Number of nearest neighours set to k=150
#> Identifying potential outlier samples...
#> Stratifying samples into sepsis response signature (SRS) groups...
#> Assigning samples a quantitative sepsis response signature score (SRSq)...
#> ... done!
#> 
#> Identifying mNN outliers at k=31...
#> Estimating variance in SRSq prediction for different values of k...Plotting SRSq predictions as a function of k...
```

<img src="man/figures/README-sensitivity_analysis_with_outliers-1.png" width="100%" style="display: block; margin: auto;" />

    #> Plotting variance in SRSq estimation for each sample...

<img src="man/figures/README-sensitivity_analysis_with_outliers-2.png" width="100%" style="display: block; margin: auto;" />

    #> ...done!

Under this last scenario, the sensitivity analysis suggests we should
exclude at least a subset of the samples flagged as outliers.

## Contact

Eddie Cano-Gamez: <ecg@well.ox.ac.uk>
