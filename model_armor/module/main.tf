terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0"
    }
  }
}

# Create multiple Vertex AI Model Armor templates
module "model_armor_templates" {
  source  = "GoogleCloudPlatform/vertex-ai/google//modules/model-armor-template"
  version = "~> 2.0"

  for_each = var.templates

  project_id  = each.value.project_id
  template_id = each.value.template_id
  location    = each.value.location

  rai_filters                      = each.value.rai_filters
  pi_and_jailbreak_filter_settings = each.value.pi_and_jailbreak_filter_settings

  enable_malicious_uri_filter_settings = each.value.enable_malicious_uri_filter_settings

  sdp_settings = {
    basic_config_filter_enforcement = each.value.basic_config_filter_enforcement
  }

  metadata_configs = each.value.metadata_configs
}