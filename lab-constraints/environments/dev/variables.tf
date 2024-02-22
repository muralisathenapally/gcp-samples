variable "target_ids" {
  type        = list(any)
  description = "Variable for project or folder or organization ID."
}

variable "target_level" {
  type        = string
  description = "String variable to denote if policy being created is at project or folder or organization level."
}
variable "exclude_projects_skip_default_network_creation" {
  type        = list(any)
  description = "project ids to be excluded from skip default network creation policy"
  default     = []
}

variable "exclude_projects_block_vm_external_ip" {
  type        = list(any)
  description = "project ids to be excluded from block external ip for vm policy"
  default     = []
}

variable "allowed_external_ip_vms" {
  default = {}
}