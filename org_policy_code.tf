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

allowed_models = 
  "publishers/qwen/models/qwen3-next:deploy",
  "publishers/qwen/models/qwen3-next-80b-a3b-instruct-maas:deploy",
  "publishers/qwen/models/qwen3-next-80b-a3b-thinking-maas:deploy",
  "publishers/qwen/models/qwen-image:deploy",
  "publishers/qwen/models/qwen3-vl:deploy",
  "publishers/qwen/models/qwen3-coder:deploy",
  "publishers/qwen/models/qwen3-coder-480b-a35b-instruct-maas:deploy",
  "publishers/qwen/models/qwen3-235b-a22b-instruct-2507-maas:deploy",
  "publishers/qwen/models/qwen3:deploy",
  "publishers/qwen/models/qwen2:deploy",
  "publishers/aisingapore/models/gemma-sea-lion-v4:deploy",
  "publishers/wan-ai/models/wan2-1:deploy",
  "publishers/wan-ai/models/wan2-2:deploy",
  "publishers/moonshotai/models/kimi-k2:deploy",
  "publishers/baai/models/bge:deploy",
  "publishers/nari-labs/models/dia-1.6b:deploy",
  "publishers/qwen/models/qwen3-next:tune",
  "publishers/qwen/models/qwen3-next-80b-a3b-instruct-maas:tune",
  "publishers/qwen/models/qwen3-next-80b-a3b-thinking-maas:tune",
  "publishers/qwen/models/qwen-image:tune",
  "publishers/qwen/models/qwen3-vl:tune",
  "publishers/qwen/models/qwen3-coder:tune",
  "publishers/qwen/models/qwen3-coder-480b-a35b-instruct-maas:tune",
  "publishers/qwen/models/qwen3-235b-a22b-instruct-2507-maas:tune",
  "publishers/qwen/models/qwen3:tune",
  "publishers/qwen/models/qwen2:tune",
  "publishers/aisingapore/models/gemma-sea-lion-v4:tune",
  "publishers/wan-ai/models/wan2-1:tune",
  "publishers/wan-ai/models/wan2-2:tune",
  "publishers/moonshotai/models/kimi-k2:tune",
  "publishers/baai/models/bge:tune",
  "publishers/nari-labs/models/dia-1.6b:tune",
  "publishers/qwen/models/qwen3-next:predict",
  "publishers/qwen/models/qwen3-next-80b-a3b-instruct-maas:predict",
  "publishers/qwen/models/qwen3-next-80b-a3b-thinking-maas:predict",
  "publishers/qwen/models/qwen-image:predict",
  "publishers/qwen/models/qwen3-vl:predict",
  "publishers/qwen/models/qwen3-coder:predict",
  "publishers/qwen/models/qwen3-coder-480b-a35b-instruct-maas:predict",
  "publishers/qwen/models/qwen3-235b-a22b-instruct-2507-maas:predict",
  "publishers/qwen/models/qwen3:predict",
  "publishers/qwen/models/qwen2:predict",
  "publishers/aisingapore/models/gemma-sea-lion-v4:predict",
  "publishers/wan-ai/models/wan2-1:predict",
  "publishers/wan-ai/models/wan2-2:predict",
  "publishers/moonshotai/models/kimi-k2:predict",
  "publishers/baai/models/bge:predict",
  "publishers/nari-labs/models/dia-1.6b:predict"
]
