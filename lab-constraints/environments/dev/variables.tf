variable "target_id" {
  type        = string
  description = "Variable for project or folder or organization ID."
}

variable "target_level" {
  type        = string
  description = "String variable to denote if policy being created is at project or folder or organization level."
  default     = "project"
}