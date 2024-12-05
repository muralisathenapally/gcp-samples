variable "projects" {
  description = "List of project configurations."
  type = list(object({
    project_id             = string
    budget_display_name    = string
    credit_types_treatment = string
    threshold_percentages  = list(number)
  }))
}