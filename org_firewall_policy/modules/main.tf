resource "google_compute_firewall_policy" "default" {
  parent      = var.firewall_policy_parent
  short_name  = "deny-ssh-rdp-http-port"
  description = "block ssh rdp http ports at org level"
}

resource "google_compute_firewall_policy_rule" "fw-rule" {
  firewall_policy = google_compute_firewall_policy.default.id
  description     = "deny-ssh-rdp-http-port"
  priority        = 9000
  enable_logging  = true
  action          = "deny"
  direction       = "INGRESS"
  disabled        = false
  match {
    layer4_configs {
      ip_protocol = "tcp"
      ports       = var.ports_to_block
    }
    src_ip_ranges = ["0.0.0.0/0"]
  }
}



resource "google_compute_firewall_policy_association" "default" {
  firewall_policy   = google_compute_firewall_policy.default.id
  attachment_target = var.attachment_target
  name              = var.firewall_policy_association_nanme
}






