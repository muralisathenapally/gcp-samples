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
  "publishers/meta/models/llama3:deploy",
  "publishers/google/models/gemini-2.0-flash-001:tune",
  "publishers/hf-google/models/gemma-2b:deploy"
]
