variable "org_id" {
    type = string
    description = "organization id in format: organizations/123456789"
}
variable "policy_name" {
    type = string
    description = "name of policy"
}
variable "perimeter_name" {
    type = string
    description = "name for the vpc perimeter"
}
variable "description" {
    type = string
    description = "description for the vpc perimeter"
}
variable "resources" {
    type = list(string)
    description = "project to be included in the perimeter. format: project/project_number"
}
variable "restricted_services" {
    type = list(string)
    description = "services to restrict"
}
variable "ingress_policies" {
  type = list(object({
    from = any
    to   = any
  }))
  default = []
}
variable "egress_policies" {
  type = list(object({
    from = any
    to   = any
  }))
  default = []
}
variable "folder_id" {
    type = number
    description = "folder id in which the project exists"
}