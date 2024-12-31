variable "project_id" {
}

variable "secret_id" {
}

variable "replication" {
  type = map(object({
    kms_key_name = string
  }))
  default = {}
}

variable "accessors" {
  type    = list(string)
  default = []
}

variable "labels" {
  type    = map(string)
  default = {}
}

variable "rotation_details" {
}

variable "setup_secret_manager" {

}
