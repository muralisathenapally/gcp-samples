projects = [
  {
    project_id             = "your-project_id"
    billing_account_id     = "billing_account_id"
    budget_display_name    = "Project 1 Budget"
    credit_types_treatment = "EXCLUDE_ALL_CREDITS"
    budget_amount          = "350"
    threshold_percentages  = [0.7, 0.8, 0.9]
    notification_channel_emails = [
      "alert1@gmail.com",
      "alert2@gmail.com",
      "alert3@gmail.com"
    ]
  },
  {
    project_id             = "your-project_id"
    billing_account_id     = "billing_account_id"
    budget_display_name    = "Project 2 Budget"
    credit_types_treatment = "EXCLUDE_ALL_CREDITS"
    budget_amount          = "350"
    threshold_percentages  = [0.7, 0.8, 0.9]
    notification_channel_emails = [
      "alert1@gmail.com",
      "alert2@gmail.com"
    ]
  }
]
