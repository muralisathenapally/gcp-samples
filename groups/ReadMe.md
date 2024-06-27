terraform init

terraform import google_cloud_identity_group.group groups/GROUP_ID   

#you can get GROUP_ID from gcp console

terraform plan

terraform apply


gcloud auth application-default login --scopes=https://www.googleapis.com/auth/admin.directory.group,https://www.googleapis.com/auth/admin.directory.group.readonly


gcloud alpha identity groups config export --all --resource-format=terraform
