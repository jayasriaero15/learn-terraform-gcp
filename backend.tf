terraform {
  backend "gcs" {
    name   = "terraform-state-file.tfstate"
    bucket = "terraform-state-file-project-af5a9a8c-a838-417b-891"
    prefix = "terraform/state"
  }
}