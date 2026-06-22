/*
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

######## VPC peering a->b project #######################
resource "google_compute_network" "vpc_a" {
  name                    = "vpc-a"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_a_subnetwork" {
  name          = "vpc-a-subnet"
  ip_cidr_range = "10.0.1.0/28"
  network       = google_compute_network.vpc_a.id
  region        = "asia-south2"
}

resource "google_compute_firewall" "vpc_a_firewall" {
  name    = "vpc-a-firewall"
  network = google_compute_network.vpc_a.name
  allow {
    protocol = "icmp"
  }
  source_ranges = ["10.0.2.0/28"]
}

resource "google_compute_instance" "proj_a_instance" {
  name         = "proj-a-instance"
  machine_type = "f1-micro"
  zone         = "asia-south2-a"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network    = google_compute_network.vpc_a.name
    subnetwork = google_compute_subnetwork.vpc_a_subnetwork.name
  }
}

# Peering from A → B
resource "google_compute_network_peering" "peer_a_to_b" {
  name         = "peer-a-to-b"
  network      = google_compute_network.vpc_a.self_link
  peer_network = var.peer_network_b
}

*/

resource "google_compute_instance_template" "default" {
  name         = "web-template"
  machine_type = "f1-micro"
  region       = var.region

  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = google_compute_network.vpc_1.id
    access_config {}
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y nginx
    systemctl enable nginx
    systemctl start nginx
  EOT
}

resource "google_compute_instance_group_manager" "default" {
  name               = "web-mig"
  base_instance_name = "web"
  region             = var.region
  version {
    instance_template = google_compute_instance_template.default.id
  }
  target_size = 2
}

resource "google_compute_health_check" "default" {
  name               = "web-health"
  check_interval_sec = 5
  timeout_sec        = 5
  http_health_check {
    port = 80
  }
}

resource "google_compute_backend_service" "default" {
  name                  = "web-backend"
  protocol              = "HTTP"
  port_name             = "http"
  timeout_sec           = 10
  health_checks         = [google_compute_health_check.default.id]
  backend {
    group = google_compute_instance_group_manager.default.instance_group
  }
}

resource "google_compute_url_map" "default" {
  name            = "web-url-map"
  default_service = google_compute_backend_service.default.id
}

resource "google_compute_target_http_proxy" "default" {
  name   = "web-http-proxy"
  url_map = google_compute_url_map.default.id
}

resource "google_compute_global_forwarding_rule" "web_rule" {
  name       = "web-rule"
  target     = google_compute_target_http_proxy.web_proxy.self_link
  port_range = "80"
}


