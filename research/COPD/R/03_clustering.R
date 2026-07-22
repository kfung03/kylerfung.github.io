if (!exists("model_data")) source("R/02_missing_data.R")

pam_silhouette_width <- function(dissimilarity, max_k = 10) {
  candidate_k <- 2:min(max_k, nrow(as.matrix(dissimilarity)) - 1)
  widths <- vapply(candidate_k, function(k) {
    cluster::pam(dissimilarity, k = k, diss = TRUE)$silinfo$avg.width
  }, numeric(1))

  data.frame(k = candidate_k, average_silhouette_width = widths)
}

set.seed(10)
unsupervised_rf <- randomForest::randomForest(
  x = model_data,
  ntree = 1000,
  proximity = TRUE,
  importance = TRUE
)

rf_dissimilarity <- 1 - unsupervised_rf$proximity
silhouette_results <- pam_silhouette_width(rf_dissimilarity, max_k = 10)

selected_k <- silhouette_results$k[
  which.max(silhouette_results$average_silhouette_width)
]

# Preserve the original research choice of five clusters when feasible.
project_k <- if (5 %in% silhouette_results$k) 5 else selected_k

pam_fit <- cluster::pam(rf_dissimilarity, k = project_k, diss = TRUE)
cluster_assignments <- factor(pam_fit$clustering)
cluster_counts <- as.data.frame(table(cluster = cluster_assignments))

mds_coordinates <- cmdscale(as.dist(rf_dissimilarity), k = 2)
mds_data <- data.frame(
  dimension_1 = mds_coordinates[, 1],
  dimension_2 = mds_coordinates[, 2],
  cluster = cluster_assignments
)

mds_plot <- ggplot2::ggplot(
  mds_data,
  ggplot2::aes(dimension_1, dimension_2, shape = cluster)
) +
  ggplot2::geom_point(alpha = 0.65) +
  ggplot2::labs(x = "MDS dimension 1", y = "MDS dimension 2")

saveRDS(unsupervised_rf, file.path(results_dir, "unsupervised_rf.rds"))
write.csv(silhouette_results, file.path(results_dir, "silhouette_results.csv"), row.names = FALSE)
write.csv(mds_data, file.path(results_dir, "cluster_mds_coordinates.csv"), row.names = FALSE)
