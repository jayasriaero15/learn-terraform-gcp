resource "google_service_account" "grafana_monitoring" {
  account_id   = "grafana-monitoring"
  display_name = "grafana monitoring service account"
  project      = var.project_id
}

resource "google_project_iam_member" "grafana_role_binding" {
  project = var.project_id
  member  = "serviceAccount:${google_service_account.grafana_monitoring.email}"
  role    = "roles/monitoring.viewer"
}

# workload identity binding 
resource "google_service_account_iam_member" "grafana_wi_binding" {
  service_account_id = google_service_account.grafana_monitoring.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[monitoring/grafana]"
}

