firewall_details = {
  "project-1" = {
    project       = "sonic-cumulus-413015"
    firewall_name = "block-ssh-rdp-http"
    ports_to_block = ["22", "80", "3389"]
    network       = "default"
  },
  "project-2" = {
    project       = "sonic-cumulus-413015"
    firewall_name = "block-ssh-rdp-http"
    ports_to_block = ["22", "80", "3389"]
    network       = "default"
  }
}