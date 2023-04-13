variable "account_id" {
      type        = string
  description = "The account id that is used to generate the service account email address"
}

variable "display_name" {
  type        = string
  description = "Display names of the created service accounts (defaults to 'Terraform-managed service account')"
  default     = "Terraform-managed service account"
}

variable "description" {
  type        = string
  description = "Default description of the created service accounts (defaults to no description)"
  default     = ""
}

variable "project_id" {
  type        = string
  description = "Project id where service account will be created."
}

variable "roles" {
  type = list(string)
  description = "Roles to be attached to service account after creation. Any roles other than the allowed_roles are ignored"
}
