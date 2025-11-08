variable "templates" {
  description = "Templates to create for dev environment"
  type = map(object({
    project_id                           = string
    template_id                          = string
    location                             = string
    rai_filters                          = map(string)
    pi_and_jailbreak_filter_settings     = string
    enable_malicious_uri_filter_settings = bool
    basic_config_filter_enforcement      = bool
    metadata_configs                     = map(any)
  }))
}
