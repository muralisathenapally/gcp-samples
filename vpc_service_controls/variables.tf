variable "org_id" {
  type        = string
  description = "organization id in format: organizations/123456789"
}
variable "policy_name" {
  type        = string
  description = "name of policy"
}
variable "perimeter_name" {
  type        = string
  description = "name for the vpc perimeter"
}
variable "description" {
  type        = string
  description = "description for the vpc perimeter"
}
variable "resources" {
  type        = list(string)
  description = "project to be included in the perimeter. format: project/project_number"
}
variable "restricted_services" {
  type        = list(string)
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
  type        = number
  description = "folder id in which the project exists"
}

variable "access_level_name" {
  description = "Description of the AccessLevel and its use. Does not affect behavior."
  type        = string
}

variable "access_level_ip_subnetworks" {
  description = "Condition - A list of CIDR block IP subnetwork specification. May be IPv4 or IPv6. Note that for a CIDR IP address block, the specified IP address portion must be properly truncated (i.e. all the host bits must be zero) or the input is considered malformed. For example, \"192.0.2.0/24\" is accepted but \"192.0.2.1/24\" is not. Similarly, for IPv6, \"2001:db8::/32\" is accepted whereas \"2001:db8::1/32\" is not. The originating IP of a request must be in one of the listed subnets in order for this Condition to be true. If empty, all IP addresses are allowed."
  type        = list(string)
  default     = []
}

variable "access_level_members" {
  description = "Condition - An allowed list of members (users, service accounts). The signed-in identity originating the request must be a part of one of the provided members. If not specified, a request may come from any user (logged in/not logged in, etc.). Formats: user:{emailid}, serviceAccount:{emailid}"
  type        = list(string)
  default     = []
}

variable "access_level_regions" {
  description = "Condition - The request must originate from one of the provided countries/regions. Format: A valid ISO 3166-1 alpha-2 code."
  type        = list(string)
  default     = []
}
