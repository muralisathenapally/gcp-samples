GCP Samples

gcloud org-policies reset serviceuser.services --project=foo-project


/etc/google-cloud-ops-agent/config.yaml

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


sudo systemctl restart google-cloud-ops-agent"*"
sudo systemctl status google-cloud-ops-agent"*"
      

      
