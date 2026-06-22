/*
resource "google_service_account" "vm_sa" {
  account_id   = "vm-sa-api-access"
  display_name = "vm service account private access"
}

resource "google_project_iam_member" "storage_access" {
  member  = "serviceAccount:${google_service_account.vm_sa.email}"
  role    = "roles/storage.objectViewer"
  project = var.project_id
}
*/
