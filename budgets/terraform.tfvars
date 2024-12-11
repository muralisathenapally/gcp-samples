project_id = ""

notification_channel_emails = [
  "alert1@example.com",
  "alert2@example.com",
  "alert3@example.com"
]

projects = [
  {
    project_id             = "project-id"
    billing_account_id     = "billing-account-id"
    budget_display_name    = "Project 1 Budget"
    credit_types_treatment = "EXCLUDE_ALL_CREDITS"
    budget_amount          = "350"
    threshold_percentages  = [0.7, 0.8, 0.9]
  }
]
