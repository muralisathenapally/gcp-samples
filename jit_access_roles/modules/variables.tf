variable "target_id" {
  description = "The ID of the project or org"
  type        = string
}

variable "target_level" {
  description = "The level at which to apply the IAM bindings (either 'project' or 'org')."
  type        = string
}
variable "members" {
  description = "The members to assign roles to."
  type        = list(string)
}

variable "roles" {
  description = "The roles to assign to members."
  type        = list(string)
}

variable "condition" {
  description = "The condition to apply."
  type = object({
    title       = string
    description = string
    expression  = string
  })
}