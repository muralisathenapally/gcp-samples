vms = [
  {
    # Instance
    instance_name    = "my-gce-vm"
    gce_machine_type = "e2-medium"
    gce_zone         = "us-east4-c"
    project_id       = "YOUR_PROJECT_D"

    gce_labels = {
      env  = "dev"
      team = "platform"
    }

    gce_tags = ["allow-ssh", "allow-internal"]

    # Boot disk
    image     = "projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-v20260427"
    disk_size = 100

    # Primary network interface
    subnetwork         = "projects/YOUR_PROJECT_D/regions/us-east4/subnetworks/default"
    subnetwork_project = null # set to host project ID if using Shared VPC, else leave null

    # Additional network interface
    additional_subnetwork         = "projects/YOUR_PROJECT_D/regions/us-east4/subnetworks/test"
    additional_subnetwork_project = null # set to host project ID if using Shared VPC, else leave null

    # Service account
    service_account = "1054492051306-compute@developer.gserviceaccount.com"
  }
]