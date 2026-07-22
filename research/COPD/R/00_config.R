options(stringsAsFactors = FALSE)

required_packages <- c(
  "dplyr", "tidyr", "readr", "purrr", "ggplot2",
  "randomForest", "cluster", "rfPermute", "knitr"
)

missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]

if (length(missing_packages) > 0) {
  stop(
    "Install the following packages before continuing: ",
    paste(missing_packages, collapse = ", ")
  )
}

invisible(lapply(required_packages, library, character.only = TRUE))

set.seed(10)

data_path <- file.path("data", "data.csv")
results_dir <- "results"
figures_dir <- "figures"

dir.create(results_dir, showWarnings = FALSE, recursive = TRUE)
dir.create(figures_dir, showWarnings = FALSE, recursive = TRUE)
