resource "google_compute_network" "vpc_1" {
  name                    = "vpc-1"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_1_subnetwork" {
  name          = "vpc-1-subnetwork"
  ip_cidr_range = "10.10.0.0/20"
  region        = "asia-south2"
  network       = google_compute_network.vpc_1.id
}

resource "google_compute_router" "vpc_1_router" {
  name    = "vpc-1-router"
  network = google_compute_network.vpc_1.id
  region  = "asia-south2"
}

resource "google_compute_router_nat" "vpc_1_router_nat" {
  name                               = "vpc-1-router-nat"
  router                             = google_compute_router.vpc_1_router.name
  region                             = "asia-south2"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_compute_firewall" "vpc_1_allow_firewall_to_iap" {
  name    = "allow-firewall-iap-tunneling"
  network = google_compute_network.vpc_1.id
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["iap-ssh"]
}