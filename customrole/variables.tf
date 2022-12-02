variable "role_id" {
  type        = string
  description = "Camel case role id to use for this role. Ex:MyCustomRole, Cannot contain - characters"
}
variable "title" {
  type        = string
  description = "A human-readable title for the role"
}
variable "permissions" {
  type        = list(string)
  description = "The names of the permissions this role grants when bound in an IAM policy. At least one permission must be specified"
}
variable "description" {
  type        = string
  description = "A human-readable description for the role"
}
variable "target_level" {
  type        = string
  description = "Where to create role. allowed values are: project or org"
}
variable "target_id" {
  type        = string
  description = "Id of the project or org, depends on the target_level i.e if target_level is org, provide org id, if target_level is project then provide project id"
}