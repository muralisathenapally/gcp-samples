module "secret" {
  source     = "memes/secret-manager/google"
  version    = "2.0.0"
  project_id = var.project_id
  id         = var.secret_id
  secret     = var.secret
  accessors  = var.secret_accessor
  replication = var.replication
}