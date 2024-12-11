# Use of CentileBrain Models Excluding Global Measures as Covariates
The CentileBrain Models were developed using brain morphometric data from multiple cohorts shown in the [Data Vault](https://centilebrain.org/#/explore). [**These models**](https://github.com/CentileBrain/centilebrain/tree/main/models) provide parameters for generating normative deviation measures for subcortical volumes, cortical thickness, and cortical surface area, separately for males and females, from any dataset.

Below we provide a demonstration of the CentileBrain Models (of the version excluding global measures as covariates) by applying the model parameters to a multi-site dataset of subcortical volumes from males. The following script can also be applied to other morphometric measures for both males and females.

Researchers wishing to apply the optimised CentileModel parameters we provide to generate normative deviation measures for their own datasets should go to [Generate Normative Deviation Values for Your Data](https://centilebrain.org/#/model).

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


### 2. Data Preparation

#### 2.1 Importing the users' data

Download template [**(template_cortical-thickness-male.csv)**]([https://github.com/CentileBrain/centilebrain/blob/main/models_without_globalMeasures/template_subcortical-volume-male.csv]) and populate this template with your own data. The CentileBrain models will not function if there are missing data on the input spreadsheet. Users can either remove study participants with missing data or impute the missing data. 
```{r}
data_original <- read.csv(".../template_cortical-thickness-male.csv")
```

#### 2.2 Site Harmonization of the users' data

Download and read the [**Python script of ComBat-GAM**](https://github.com/CentileBrain/centilebrain/blob/3ffe05cfd2b52591662c8648a2079c363f079f32/models/combatGAM_Python4R.py) within the R environment.
```{r message=FALSE, warning=FALSE, results=FALSE}
source_python("I:/CentileBrain/scripts//combatGAM_Python4R.py")
```
Site harmonization of the demonstration data is implemented using [ComBat-GAM](https://github.com/rpomponio/neuroHarmonize) as follows:
```{r message=FALSE, warning=FALSE, results=FALSE}
covars_temp = data[,c("SITE","age")]
data_temp = data_original[,c(3:16)] # change 3:16 to 3:70 for cortical thickness and cortical surface area measures
write.csv(covars_temp[,1:2],".../covars_temp.csv", row.names = FALSE)
write.csv(data_temp,".../data_temp.csv", row.names = FALSE)
adjustedData_model <- combatGAM_R_new(".../")
data_harmonized <- data.frame(adjustedData_model[[1]])

data = data.frame(matrix(0, nrow = nrow(data_original), ncol = ncol(data_original)))
data[,c(1,2)] = covars_temp
data[,c(3:16)] = data_harmonized # change 3:16 to 3:70 for cortical thickness and cortical surface area measures
names(data) <- colnames(data_original)
```

### 3. Application of CentileBrain model parameters to the demonstration data

#### 3.1 Loading the pre-trained CentileBrain model (note this version of the model is excluding the global measures as covariates) 

The script below loads the parameters for female subcortical volumes.
```{r}
CentileBrain_mfpModel_list <- readRDS(".../MFPmodels_subcorticalvolume_male.rds")
for (i in 1:14){
  a = CentileBrain_mfpModel_list[[i]]
  attr(a$terms, ".Environment") <- globalenv()
  attr(a$fit$terms, ".Environment") <- globalenv()
  CentileBrain_mfpModel_list[[i]] = a
}
```

#### 3.2 Application of the CentileBrain model parameters

The script below applies the CentileBrain model parameters to the demo data, and return the results.
```{r}
prediction_list <- NULL
z_score_list <- NULL
mae_list <- matrix(nrow = 1, ncol = 14) # change ncol = 14 to ncol = 68 for cortical thickness and cortical surface area measures
rmse_list <- matrix(nrow = 1, ncol = 14)
ev_list <- matrix(nrow = 1, ncol = 14)
corr_list <- matrix(nrow = 1, ncol = 14)
MSLL_list <- matrix(nrow = 1, ncol = 14)
newdat <- data_centered[,2:3]
for (region in 3:ncol(data)){
  newdat[,2] =  newdat[,2] ###########################
  predicted <- predict(CentileBrain_mfpModel_list[[region-2]],newdata = newdat)
  prediction_list[region-2] <- data.frame(predicted)
  z_score <- (data_centered[region]-predicted)/sqrt(sum(CentileBrain_mfpModel_list[[region-2]]$residuals**2)/length(CentileBrain_mfpModel_list[[region-2]]$residuals))
  z_score_list[region-2] <- z_score
  mae_list[1,region-2] <- sum(abs(data_centered[region]-predicted))/nrow(data_centered)
  rmse_list[1,region-2] <- sqrt(1/(nrow(data_centered))*sum((data_centered[region]-predicted)**2))
  corr_list[1,region-3] <- cor(data_centered[region],predicted)
  ev_list[1,region-2] <- 1-var(data_centered[region]-predicted)/var(data_centered[region])
  newdat <- data_centered[,2:3]
}
```

Save the results.
```{r}
names(prediction_list) = names(data[,3:ncol(data)])
names(z_score_list) = names(data[,3:ncol(data)])
write.csv(prediction_list,".../prediction_subcorticalvolume_male.csv",row.names=FALSE)
write.csv(z_score_list,".../z-score_subcorticalvolume_male.csv",row.names=FALSE)
write.csv(mae_list,".../mae_list.csv",row.names=FALSE)
write.csv(rmse_list,".../rmse_list.csv",row.names=FALSE)
write.csv(corr_list,".../corr_list.csv",row.names=FALSE)
write.csv(ev_list,".../ev_list.csv",row.names=FALSE)
write.csv(MSLL_list,".../MSLL_list.csv",row.names=FALSE)
```


\
\


