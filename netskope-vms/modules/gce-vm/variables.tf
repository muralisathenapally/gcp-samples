variable "instance_name" {
  description = "Name of the GCE instance"
  type        = string
}

variable "gce_machine_type" {
  description = "Machine type for the GCE instance (must support multiple NICs, e.g. n1-standard-2)"
  type        = string
}

variable "gce_zone" {
  description = "Zone to deploy the GCE instance"
  type        = string
}

variable "gce_labels" {
  description = "Labels to apply to the GCE instance"
  type        = map(string)
  default     = {}
}

variable "gce_tags" {
  description = "Network tags to apply to the GCE instance"
  type        = list(string)
  default     = []
}

variable "project_id" {
  description = "GCP project ID where the VM will be created"
  type        = string
}

variable "image" {
  description = "Boot disk image for the GCE instance"
  type        = string
}

variable "disk_size" {
  description = "Boot disk size in GB"
  type        = number
}

# Primary network interface
variable "subnetwork" {
  description = "Self-link or name of the primary subnetwork"
  type        = string
}

variable "subnetwork_project" {
  description = "Project hosting the primary subnetwork. Defaults to project_id if not set."
  type        = string
  default     = null
}

variable "ip_address" {
  description = "Static internal IP for the primary network interface"
  type        = string
  default     = ""
}

# Additional network interface
variable "additional_subnetwork" {
  description = "Self-link or name of the additional subnetwork"
  type        = string
}

variable "additional_subnetwork_project" {
  description = "Project hosting the additional subnetwork. Defaults to project_id if not set."
  type        = string
  default     = null
}

variable "additional_ip_address" {
  description = "Static internal IP for the additional network interface (optional)"
  type        = string
  default     = ""
}

# Service account
variable "service_account" {
  description = "Service account email to attach to the GCE instance"
  type        = string
}
