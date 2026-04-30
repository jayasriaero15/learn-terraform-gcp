resource "google_compute_instance" "vpc_1_instance" {
  name         = "vpc-1-instance"
  machine_type = "f1-micro"
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.vpc_1_subnetwork.name
  }
}