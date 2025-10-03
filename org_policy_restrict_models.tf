resource "google_org_policy_policy" "vertexai_allowed_models" {
  name = "organizations/${var.org_id}/policies/vertexai.allowedModels"

  spec {
    rules {
      values {
        allowed_values = var.allowed_models
      }
    }
  }
}


##====================================================##

variable "org_id" {
  description = "The organization ID where the policy will be applied"
  type        = string
}

variable "allowed_models" {
  description = "List of allowed Vertex AI models"
  type        = list(string)
}

##====================================================##

org_id = "1234567890"

allowed_models = [
  "publishers/meta/models/llama3:deploy",
  "publishers/google/models/gemini-2.0-flash-001:tune",
  "publishers/hf-google/models/gemma-2b:deploy"
]
