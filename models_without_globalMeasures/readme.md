# Use of CentileBrain Models Excluding Global Measures as Covariates
The CentileBrain Models were developed using brain morphometric data from multiple cohorts shown in the [Data Vault](https://centilebrain.org/#/explore). [**These models**](https://github.com/CentileBrain/centilebrain/tree/main/models) provide parameters for generating normative deviation measures for subcortical volumes, cortical thickness, and cortical surface area, separately for males and females, from any dataset.

Researchers wishing to apply the CentileModel parameters we provide to generate normative deviation measures for their own datasets should go to [Generate Normative Deviation Values for Your Data](https://centilebrain.org/#/model).

Below we provide a demonstration of the CentileBrain Models by applying the model parameters to a multi-site dataset of subcortical volumes from males. The script applies to other morphometric measures of males and females. 

### 1. Environment Setup

The scripts provided run in the [R environment](https://www.r-project.org/about.html).
```{r message=FALSE, warning=FALSE}
library(mfp)
library(writexl)
library(tidyr)
library(R.matlab)
```

The ComBat-GAM algorithm used below will need [Python environment](https://www.python.org/), here we will use R package "reticulate" to connect Python and R. Please refer to https://rstudio.github.io/reticulate/ to setup the Python environment.The required Python modules or packages include ["numpy"](https://numpy.org/), ["pandas"](https://pandas.pydata.org/), ["nibabel"](https://nipy.org/nibabel/), ["statsmodels"](https://www.statsmodels.org/stable/index.html), and ["neuroHarmonize"]((https://github.com/rpomponio/neuroHarmonize)).

Load the "reticulate" package to R environment.
```{r message=FALSE, warning=FALSE}
library(reticulate)
```

