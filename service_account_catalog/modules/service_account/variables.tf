variable "account_id" {

}

variable "display_name" {

}

variable "description" {

}

variable "project_id" {
  
}

variable "roles" {
  
}

variable "allowed_roles" {
  type = list(string)
  description = "These are the only allowed roles"
  default = ["roles/editor","roles/viewer","roles/compute.admin"]
}
