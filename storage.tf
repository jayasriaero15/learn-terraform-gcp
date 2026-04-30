resource "google_storage_bucket" "terraform_state_file" {
  name     = "terraform-state-file-project-af5a9a8c-a838-417b-891"
  location = "ASIA"
  versioning {
    enabled = true
  }
  uniform_bucket_level_access = true
  force_destroy               = false
  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }
}