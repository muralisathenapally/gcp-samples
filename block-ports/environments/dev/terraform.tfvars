firewall_details = {
  "project-1" = {
    project       = "psyched-circuit-4053125"
    firewall_name = "block-ssh-rdp-http"
    ports_to_block = ["22", "80", "3389"]
    network       = "default"
  },
  "project-2" = {
    project       = "psyched-circuit-405312"
    firewall_name = "block-ssh-rdp-http"
    ports_to_block = ["22", "80", "3389"]
    network       = "default"
  }
}
