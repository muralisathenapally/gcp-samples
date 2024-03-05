resource "google_monitoring_monitored_project" "projects_monitored" {
  for_each      = toset(var.monitored_projects)
  metrics_scope = join("", ["locations/global/metricsScopes/", var.monitoring_project])
  name          = each.value
}