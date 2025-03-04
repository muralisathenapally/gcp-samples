GCP Samples

gcloud org-policies reset serviceuser.services --project=foo-project


/etc/google-cloud-ops-agent/config.yaml

    nessus-agent-dr_log:
      type: files
      include_paths:
      - /opt/nessus_agent/var/nessus/logs/*

receivers: [nessus-agent-dr_log]


    nessus-scanner-dr_log:
      type: files
      include_paths:
      - /opt/nessus/var/nessus/logs/*

receivers: [nessus-scanner-dr_log]


sudo systemctl restart google-cloud-ops-agent"*"
      

      

https://cloud.google.com/architecture/framework
