variable "projects" {
  description = "List of project configurations."
  type = list(object({
    project_id             = string
    billing_account_id     = string
    budget_display_name    = string
    credit_types_treatment = string
    threshold_percentages  = list(number)
  }))
}

variable "notification_channel_emails" {
  type = list(string)
}

variable "project_id" {}
