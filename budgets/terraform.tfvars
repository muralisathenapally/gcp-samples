notification_channel_emails = [
  "alert1@example.com",
  "alert2@example.com",
  "alert3@example.com"
]

projects = [
  {
    project_id             = "psyched-circuit-405312"
    billing_account_id     = "01B7A9-D05367-9489AF"
    budget_display_name    = "Project 1 Budget"
    credit_types_treatment = "EXCLUDE_ALL_CREDITS"
    threshold_percentages  = [0.7, 0.8, 0.9]
  }
]