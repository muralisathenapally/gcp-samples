GCP Samples

gcloud org-policies reset serviceuser.services --project=foo-project


    nessus-agent_log:
      type: files
      include_paths:
      - /opt/nessus_agent/var/nessus/logs/*
      record_log_files_path: true

receivers: [nessus-agent_log]


    nessus-scanner_log:
      type: files
      include_paths:
      - /opt/nessus/var/nessus/logs/*
      record_log_files_path: true

receivers: [nessus-scanner_log]

      

      
