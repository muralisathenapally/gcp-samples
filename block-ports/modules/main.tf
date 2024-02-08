resource "google_compute_firewall" "deny_ssh_http_rdp" {
  name      = var.firewall_name
  network   = var.network
  project   = var.project
  direction = "INGRESS"
  priority  = 2000

  deny {
    protocol = "tcp"
    ports    = var.ports
  }
  source_ranges = ["0.0.0.0/0"]
}