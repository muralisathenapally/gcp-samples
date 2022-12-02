variable "machine_type" {
  type    = string
  default = "n1-standard-1"
}

variable "zone" {
  type    = string
  default = "us-east4-a"
}

variable "instance_name" {
  description = "The unique name for your instance"
  type        = string
}