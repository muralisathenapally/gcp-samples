# Terraform GCP Billing Budget Setup

This Terraform module automates the setup of billing budgets and monitoring notification channels creation for Google Cloud projects. It enables billing alerts and notifications for multiple projects using Google Cloud Monitoring.

## Features

- Enables required GCP services (`cloudbilling.googleapis.com`, `billingbudgets.googleapis.com`).
- Creates billing budget policies for specified projects.
- Configures notification channels for budget alerts.
- Supports multiple projects via `tfvars` file.


## Variables

| Variable Name                 | Description                                      |
|--------------------------------|--------------------------------------------------|
| `project_id`                   | GCP Project ID.                                 |
| `billing_account_id`           | GCP Billing Account ID.                         |
| `budget_display_name`         | Name of the budget.                             |
| `credit_types_treatment`      | Defines how credits are handled (e.g., `EXCLUDE_ALL_CREDITS`). |
| `budget_amount`               | Budget limit in USD.                            |
| `threshold_percentages`       | Percentage thresholds for alerts (e.g., `0.7, 0.8, 0.9`). |
| `notification_channel_emails` | List of email addresses for alerts.             |

## Example `terraform.tfvars`

```hcl
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
  }
]
```

