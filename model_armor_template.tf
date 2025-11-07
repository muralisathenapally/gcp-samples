module "model_armor_template" {
  source  = "GoogleCloudPlatform/vertex-ai/google//modules/model-armor-template"
  version = "~> 2.0"

  template_id = "test-model-armor-template"
  location    = "us"
  project_id  = "YOUR-PROJECT-ID"

  rai_filters = {
    dangerous         = "LOW_AND_ABOVE"
    sexually_explicit = "MEDIUM_AND_ABOVE"
  }

  enable_malicious_uri_filter_settings = true

  pi_and_jailbreak_filter_settings = "MEDIUM_AND_ABOVE"

  sdp_settings = {
      advanced_config = {
        inspect_template     = "projects/{project}/locations/{location}/inspectTemplates/{inspect_template}"
        deidentify_template  = "projects/{project}/locations/{location}/deidentifyTemplates/{deidentify_template}"
      }
  }

  metadata_configs = {
    enforcement_type                         = "INSPECT_AND_BLOCK"
    enable_multi_language_detection          = true
    log_sanitize_operations                  = true
    log_template_operations                  = false
    ignore_partial_invocation_failures       = false
    custom_prompt_safety_error_code          = "799"
    custom_prompt_safety_error_message       = "error 799"
    custom_llm_response_safety_error_message = "error 798"
    custom_llm_response_safety_error_code    = "798"
  }
}
