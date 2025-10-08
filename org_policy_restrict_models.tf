##=================== main.tf  =================================##

resource "google_org_policy_policy" "vertexai_allowed_models" {
  name     = "projects/${var.project_id}/policies/vertexai.allowedModels"
  parent   = "projects/${var.project_id}"

  spec {
    rules {
      values {
        denied_values = var.denied_models
      }
    }
  }
}


##=================== variables.tf  =================================##

variable "project_id" {
  description = "The project ID where the policy will be applied"
  type        = string
}

variable "denied_models" {
  description = "List of denied Vertex AI models"
  type        = list(string)
}

##=================== terraform.tfvards =================================##

project_id = "1234567890"

denied_models = [
  "publishers/deepseek-ai/models/deepseek-r1:*",
  "publishers/deepseek-ai/models/deepseek-v3-1:*",
  "publishers/deepseek-ai/models/deepseek-v3:*",
  "publishers/deepseek-ai/models/deepseek-v3-2:*",
  "publishers/deepseek-ai/models/deepseek-v3.1-maas:*",
  "publishers/deepseek-ai/models/deepseek-r1-0528-maas:*",
  "publishers/mistralai/models/codestral-2501:*",
  "publishers/qwen/models/qwq:*",
  "publishers/qwen/models/qwen3:*",
  "publishers/qwen/models/qwen3-235b-a22b-instruct-2507-maas:*"
]
