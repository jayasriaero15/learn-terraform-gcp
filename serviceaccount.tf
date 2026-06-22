resource "google_service_account" "composer_sa" {
  account_id   = "composer-sa"
  display_name = "composer purpose"
}

resource "google_project_iam_member" "composer_binding_role" {
  role    = "roles/editor"
  project = var.project_id
  member  = "serviceAccount:${google_service_account.composer_sa.email}"
}

resource "google_project_iam_member" "composer_worker_role" {
  role    = "roles/composer.worker"
  project = var.project_id
  member  = "serviceAccount:${google_service_account.composer_sa.email}"
}

resource "google_project_iam_member" "composer_serviceAgent_role" {
  role    = "roles/composer.ServiceAgentV2Ext"
  project = var.project_id
  member  = "serviceAccount:${google_service_account.composer_sa.email}"
}

resource "google_project_iam_member" "composer_645023212165_editor" {
  role    = "roles/editor"
  member  = "serviceAccount:645023212165@cloudservices.gserviceaccount.com"
  project = var.project_id
}

resource "google_project_iam_member" "composer_645023212165_serviceAgent" {
  role    = "roles/composer.ServiceAgentV2Ext"
  project = var.project_id
  member  = "serviceAccount:service-645023212165@cloudcomposer-accounts.iam.gserviceaccount.com"
}
