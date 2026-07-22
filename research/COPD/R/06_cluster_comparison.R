if (!exists("rf_dissimilarity")) source("R/03_clustering.R")

candidate_k <- intersect(c(2, 3, 5), silhouette_results$k)

cluster_comparison <- do.call(
  rbind,
  lapply(candidate_k, function(k) {
    fit <- cluster::pam(rf_dissimilarity, k = k, diss = TRUE)
    data.frame(
      k = k,
      average_silhouette_width = fit$silinfo$avg.width,
      smallest_cluster = min(table(fit$clustering)),
      largest_cluster = max(table(fit$clustering))
    )
  })
)

write.csv(
  cluster_comparison,
  file.path(results_dir, "cluster_comparison.csv"),
  row.names = FALSE
)
