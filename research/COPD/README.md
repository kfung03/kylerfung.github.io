# COPD Phenotype Discovery with Random Forest Clustering

This project explores potential COPD phenotypes using an unsupervised machine-learning pipeline built in R. The workflow combines missing-data assessment, median and random-forest imputation, unsupervised random-forest proximities, partitioning around medoids (PAM), cluster validation, and permutation-based variable importance.

> **Portfolio note:** The source dataset is not included in this repository by default. Place the working file at `data/data.csv` before running the analysis.

## Research objective

The goal is to identify clinically meaningful participant groups from pulmonary-function, respiratory, imaging, and engineered spirometry variables without assigning predefined outcome labels.

## Methods

1. Separate identifier/demographic variables from analysis features.
2. quantify missingness and remove unusable variables.
3. create a median-imputed baseline dataset.
4. calculate unsupervised random-forest proximities.
5. cluster the proximity-derived dissimilarities with PAM.
6. compare candidate cluster counts using average silhouette width.
7. refine missing values with `rfImpute` using initial cluster assignments.
8. evaluate cluster predictability and rank variables with random forest and `rfPermute`.

## Repository structure

```text
copd-phenotype-clustering/
├── README.md
├── analysis.qmd
├── _quarto.yml
├── .gitignore
├── R/
│   ├── 00_config.R
│   ├── 01_data_cleaning.R
│   ├── 02_missing_data.R
│   ├── 03_clustering.R
│   ├── 04_rf_imputation.R
│   ├── 05_variable_importance.R
│   └── 06_cluster_comparison.R
├── data/
│   └── README.md
├── figures/
└── results/
```

## How to run

Install the required packages:

```r
install.packages(c(
  "dplyr", "tidyr", "readr", "purrr", "ggplot2",
  "randomForest", "cluster", "rfPermute", "knitr"
))
```

Place the dataset at:

```text
data/data.csv
```

Then run the complete pipeline from the project root:

```r
source("R/01_data_cleaning.R")
source("R/02_missing_data.R")
source("R/03_clustering.R")
source("R/04_rf_imputation.R")
source("R/05_variable_importance.R")
source("R/06_cluster_comparison.R")
```

To generate the website report:

```bash
quarto render
```

## Main outputs

The scripts produce:

- missingness summaries;
- silhouette-width diagnostics;
- random-forest/PAM cluster assignments;
- multidimensional-scaling cluster plots;
- imputed analysis data;
- random-forest error estimates;
- permutation-based variable-importance tables and figures.

## Data privacy

Do not commit identifiable or restricted participant data. The supplied `.gitignore` excludes CSV and Excel files in `data/`. Publish only a data dictionary or an approved synthetic/de-identified sample.

## Limitations

The clusters are exploratory and depend on feature selection, missing-data treatment, distance construction, random seeds, and the selected number of clusters. They should be externally validated before clinical interpretation.
