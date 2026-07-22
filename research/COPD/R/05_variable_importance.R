if (!exists("imputed_classifier")) source("R/04_rf_imputation.R")

importance_matrix <- randomForest::importance(imputed_classifier)
importance_frame <- as.data.frame(importance_matrix)
importance_frame$variable <- rownames(importance_frame)

mda_name <- intersect(
  c("MeanDecreaseAccuracy", "MeanDecreaseGini"),
  names(importance_frame)
)[1]

if (is.na(mda_name)) stop("No supported importance measure was returned.")

variable_importance <- importance_frame |>
  dplyr::transmute(
    variable,
    mean_decrease_accuracy = .data[[mda_name]]
  ) |>
  dplyr::arrange(dplyr::desc(mean_decrease_accuracy))

write.csv(
  variable_importance,
  file.path(results_dir, "variable_importance.csv"),
  row.names = FALSE
)

# Permutation significance can be computationally expensive. Run it explicitly
# when needed by changing run_rf_permute to TRUE.
run_rf_permute <- FALSE

if (run_rf_permute) {
  set.seed(10)
  rf_permutation_fit <- rfPermute::rfPermute(
    cluster_group ~ .,
    data = rf_imputed_data,
    ntree = 1000,
    nrep = 100
  )
  saveRDS(rf_permutation_fit, file.path(results_dir, "rf_permutation_fit.rds"))
}
