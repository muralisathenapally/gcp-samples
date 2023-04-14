variable "account_id" {

}

variable "display_name" {

}

variable "description" {

}

variable "project_id" {

}

variable "roles" {

}

variable "allowed_roles" {
  type        = list(string)
  description = "These are the only allowed roles"
  default     = ["roles/storage.objectAdmin", "roles/bigquery.dataEditor", "roles/bigquery.user", "roles/pubsub.editor", "roles/logging.admin", "roles/monitoring.admin", "roles/file.editor", "roles/run.developer", "roles/compute.instanceAdmin.v1", "roles/datastore.owner", "roles/container.clusterAdmin", "roles/secretmanager.secretAccessor", "roles/iam.workloadIdentityUser", "roles/appengine.deployer", "roles/artifactregistry.repoAdmin", "roles/cloudkms.cryptoKeyEncrypterDecrypter", "roles/cloudfunctions.developer", "roles/cloudbuild.builds.builder", "roles/cloudsql.editor", "roles/automl.editor"]
}
