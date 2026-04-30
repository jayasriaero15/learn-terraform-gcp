resource "google_storage_bucket" "terraform_state_bucket" {
  name          = "terraform-state-file"
  location      = "ASIA"
  force_destroy = false   # safer for state bucket

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }
}
