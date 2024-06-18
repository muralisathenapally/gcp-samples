terraform init
## get id of the group from gcp console ##
terraform import google_cloud_identity_group.group groups/<group-id>
terraform plan
terraform apply