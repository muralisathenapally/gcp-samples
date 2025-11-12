templates = {
  template1 = {
    project_id  = "psyched-circuit-405312"
    template_id = "armor-template-1"
    location    = "us-central1"

    rai_filters = {
    dangerous         = "LOW_AND_ABOVE"
    sexually_explicit = "MEDIUM_AND_ABOVE"
    }

    pi_and_jailbreak_filter_settings = "MEDIUM_AND_ABOVE"

    enable_malicious_uri_filter_settings = true
    basic_config_filter_enforcement      = true

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

  template2 = {
    project_id  = "psyched-circuit-405312"
    template_id = "armor-template-2"
    location    = "europe-west4"

    rai_filters = {
    dangerous         = "LOW_AND_ABOVE"
    sexually_explicit = "MEDIUM_AND_ABOVE"
    }

    pi_and_jailbreak_filter_settings = "MEDIUM_AND_ABOVE"

    enable_malicious_uri_filter_settings = false
    basic_config_filter_enforcement      = false

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
}

