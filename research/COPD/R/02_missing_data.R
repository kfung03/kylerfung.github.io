if (!exists("analysis_data_raw")) source("R/01_data_cleaning.R")

missingness_summary <- data.frame(
  variable = names(analysis_data_raw),
  n_missing = colSums(is.na(analysis_data_raw)),
  pct_missing = 100 * colMeans(is.na(analysis_data_raw)),
  row.names = NULL
) |>
  dplyr::arrange(dplyr::desc(pct_missing))

write.csv(
  missingness_summary,
  file.path(results_dir, "missingness_summary.csv"),
  row.names = FALSE
)

# Exclude variables that are completely missing or have zero variance.
usable_columns <- missingness_summary |>
  dplyr::filter(pct_missing < 100) |>
  dplyr::pull(variable)

analysis_data <- analysis_data_raw |>
  dplyr::select(dplyr::all_of(usable_columns))

is_zero_variance <- vapply(
  analysis_data,
  function(x) length(unique(x[!is.na(x)])) <= 1,
  logical(1)
)
analysis_data <- analysis_data[, !is_zero_variance, drop = FALSE]

# Median imputation for numeric variables and modal imputation for factors.
mode_value <- function(x) {
  observed <- x[!is.na(x)]
  if (length(observed) == 0) return(NA)
  names(sort(table(observed), decreasing = TRUE))[1]
}

median_imputed_data <- analysis_data |>
  dplyr::mutate(
    dplyr::across(
      where(is.numeric),
      ~ ifelse(is.na(.x), median(.x, na.rm = TRUE), .x)
    ),
    dplyr::across(
      where(is.factor),
      ~ {
        replacement <- mode_value(.x)
        factor(tidyr::replace_na(as.character(.x), replacement))
      }
    )
  )

# randomForest requires complete predictors and cannot directly use dates/lists.
model_data <- median_imputed_data |>
  dplyr::select(where(~ is.numeric(.x) || is.factor(.x)))
