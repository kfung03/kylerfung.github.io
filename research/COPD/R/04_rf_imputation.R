if (!exists("cluster_assignments")) source("R/03_clustering.R")

imputation_data <- analysis_data |>
  dplyr::mutate(cluster_group = cluster_assignments)

# rfImpute can fail when predictors are perfectly collinear. Remove zero-variance
# columns here; further correlated-variable filtering may be needed for new data.
nonzero_columns <- vapply(
  imputation_data,
  function(x) length(unique(x[!is.na(x)])) > 1,
  logical(1)
)
imputation_data <- imputation_data[, nonzero_columns, drop = FALSE]

set.seed(10)
rf_imputed_data <- randomForest::rfImpute(
  cluster_group ~ .,
  data = imputation_data,
  ntree = 500,
  iter = 5
)

set.seed(10)
imputed_classifier <- randomForest::randomForest(
  cluster_group ~ .,
  data = rf_imputed_data,
  ntree = 1000,
  importance = TRUE
)

write.csv(
  rf_imputed_data,
  file.path(results_dir, "rf_imputed_cluster_data.csv"),
  row.names = FALSE
)
saveRDS(imputed_classifier, file.path(results_dir, "imputed_cluster_classifier.rds"))
