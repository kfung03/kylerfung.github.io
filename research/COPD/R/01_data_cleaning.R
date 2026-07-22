if (!exists("data_path")) source("R/00_config.R")

if (!file.exists(data_path)) {
  stop("Dataset not found. Place the working CSV at: ", data_path)
}

raw_data <- readr::read_csv(data_path, show_col_types = FALSE)

# Preserve participant information for later descriptive analyses.
identifier_candidates <- c("sid")
demographic_candidates <- c(
  "gender", "race", "finalgold_baseline.x", "Age_P1",
  "Height_CM_P1", "Weight_KG_P1", "BMI_P1"
)

identifier_columns <- intersect(identifier_candidates, names(raw_data))
demographic_columns <- intersect(demographic_candidates, names(raw_data))

participant_data <- raw_data |>
  dplyr::select(dplyr::any_of(c(identifier_columns, demographic_columns)))

analysis_data_raw <- raw_data |>
  dplyr::select(-dplyr::any_of(identifier_columns))

# Convert character columns to factors; retain numeric columns as numeric.
analysis_data_raw <- analysis_data_raw |>
  dplyr::mutate(dplyr::across(where(is.character), as.factor))

write.csv(
  data.frame(
    variable = names(raw_data),
    class = vapply(raw_data, function(x) paste(class(x), collapse = "/"), character(1))
  ),
  file.path(results_dir, "data_dictionary_classes.csv"),
  row.names = FALSE
)
