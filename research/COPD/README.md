# COPD Risk Factor Analysis

![Project status](https://img.shields.io/badge/status-portfolio%20project-blue)
![R](https://img.shields.io/badge/R-4.3%2B-276DC3)

## Project Overview

This project uses R to examine demographic, behavioral, and clinical factors associated with chronic obstructive pulmonary disease (COPD). The workflow includes data cleaning, exploratory data analysis, visualization, and multivariable logistic regression.

The repository is designed as a reproducible research portfolio project. It presents the main findings clearly while keeping the full R code available for technical review.

## Research Question

Which demographic, behavioral, and clinical characteristics are most strongly associated with COPD status?

## Methods

The analysis includes:

- Data cleaning and validation
- Descriptive statistics
- COPD prevalence estimates
- Exploratory visualizations
- Logistic regression modeling
- Odds-ratio interpretation
- Model diagnostics

## Repository Structure

```text
copd-github-starter/
├── README.md
├── _quarto.yml
├── index.qmd
├── analysis.qmd
├── portfolio-card.html
├── R/
│   ├── 01_data_cleaning.R
│   ├── 02_exploratory_analysis.R
│   ├── 03_statistical_models.R
│   └── 04_visualizations.R
├── data/
│   └── README.md
├── figures/
└── docs/
```

## Expected Data Columns

The example code assumes a dataset with columns similar to:

| Variable | Description |
|---|---|
| `copd` | COPD status, coded 0 or 1 |
| `age` | Age in years |
| `sex` | Sex or gender category |
| `smoking_status` | Never, former, or current smoker |
| `bmi` | Body mass index |
| `fev1` | Forced expiratory volume in one second |

Update the scripts if your variable names differ.

## How to Run the Project

1. Add a de-identified dataset to `data/copd_data.csv`.
2. Open the project in RStudio.
3. Install the required packages:

```r
install.packages(c(
  "tidyverse",
  "broom",
  "janitor",
  "here",
  "scales",
  "gt"
))
```

4. Render the Quarto project:

```bash
quarto render
```

5. Open `docs/index.html` in a browser.

## Key Skills Demonstrated

- R programming
- Data cleaning
- Epidemiological analysis
- Logistic regression
- Data visualization
- Reproducible research
- GitHub Pages publishing

## Data Privacy

Do not upload protected health information or identifiable patient data. Use a public, synthetic, or properly de-identified dataset.

## Author

**Your Name**  
[GitHub](https://github.com/YOUR-USERNAME) | [Portfolio](https://YOUR-USERNAME.github.io)
