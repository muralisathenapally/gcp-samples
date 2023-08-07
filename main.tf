# Configure Resources and Setup for CAI2PubSub2CloudRun

#------------------------------------------------------------
# Components needed
#-------------------------------------------------------------

provider "google" {
  project               = var.project
  region                = var.region
  zone                  = var.zone
  user_project_override = true
  billing_project       = var.project
}

provider "google-beta" {
  project               = var.project
  region                = var.region
  zone                  = var.zone
  user_project_override = true
  billing_project       = var.project
}

resource "google_bigquery_dataset" "notifications" {
  dataset_id = var.prjdataset
}

resource "google_bigquery_table" "notifications-data-table" {
  depends_on          = [google_bigquery_dataset.notifications]
  dataset_id          = var.prjdataset
  table_id            = var.ackstable
  deletion_protection = false

  schema = file("asset_updates.json")

  # time_partitioning {
  #   type = "DAY"
  # }
}

data "google_project" "project" {
    project_id = var.project
}

# Enable APIs needed - just to make sure #
##########################################


# Enable IAM API
resource "google_project_service" "iam" {
  service            = "iam.googleapis.com"
  disable_on_destroy = false
}

# Enable Artifact Registry API
resource "google_project_service" "artifactregistry" {
  service            = "artifactregistry.googleapis.com"
  disable_on_destroy = false
}

# Enable Cloud Run API
resource "google_project_service" "cloudrun" {
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

# Enable Cloud Resource Manager API
resource "google_project_service" "resourcemanager" {
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

# Enable Cloud Asset Inventory API
resource "google_project_service" "cloudasset" {
  service            = "cloudasset.googleapis.com"
  disable_on_destroy = false
}

# This is used so there is some time for the activation of the API's to propagate through 
# Google Cloud before actually calling them.
resource "time_sleep" "wait_60_seconds" {
  create_duration = "60s"
  depends_on = [
    google_project_service.artifactregistry,
    google_project_service.cloudrun,
    google_project_service.resourcemanager,
    google_project_service.cloudasset,
  ]
}


#    Google Artifact Registry Repository    #
#############################################

# Create Artifact Registry Repository for Docker containers
resource "google_artifact_registry_repository" "my_docker_repo" {
  location      = var.region
  repository_id = var.cai_repository
  description   = "cai docker repository"
  format        = "DOCKER"
  depends_on    = [time_sleep.wait_60_seconds]
}

resource "google_artifact_registry_repository" "my_docker_repo_1" {
  location      = var.region
  repository_id = var.ack_repository
  description   = "ack docker repository"
  format        = "DOCKER"
  depends_on    = [time_sleep.wait_60_seconds]
}


resource "null_resource" "ack-docker-image" {
  depends_on = [google_artifact_registry_repository.my_docker_repo_1]

  provisioner "local-exec" {
    command = "sed -i \"s,REPLACE_PROJECT,${var.project},g\" ./AckCloudRun/Dockerfile"
  }
  provisioner "local-exec" {
    command = "sed -i \"s,REPLACE_DATASET,${var.prjdataset},g\" ./AckCloudRun/Dockerfile"
  }
  provisioner "local-exec" {
    command = "sed -i \"s,REPLACE_TABLE,${var.ackstable},g\" ./AckCloudRun/Dockerfile"
  }
  provisioner "local-exec" {
    command = "gcloud builds submit --region=${var.region} --config ack-cloudrun-build.yaml ./AckCloudRun --substitutions=_REPOSITORY=${google_artifact_registry_repository.my_docker_repo_1.name},_DOCKER_IMG=${var.ack_docker_image},_PROJECTID=${var.project}"
  }
}

resource "null_resource" "cai-docker-image" {
  depends_on = [google_artifact_registry_repository.my_docker_repo, google_cloud_run_service.ackservice]

  provisioner "local-exec" {
    command = "sed -i \"s,REPLACE_ACKSERVICEURL,${google_cloud_run_service.ackservice.status.0.url},g\" ./CaiCloudRun/Dockerfile"
  }
  provisioner "local-exec" {
    command = "sed -i \"s,REPLACE_PROJECT,${var.project},g\" ./CaiCloudRun/Dockerfile"
  }
  provisioner "local-exec" {
    command = "sed -i \"s,REPLACE_DATASET,${var.prjdataset},g\" ./CaiCloudRun/Dockerfile"
  }
  provisioner "local-exec" {
    command = "sed -i \"s,REPLACE_TABLE,${var.ackstable},g\" ./CaiCloudRun/Dockerfile"
  }
  provisioner "local-exec" {
    command = "gcloud builds submit --region=${var.region} --config cai-cloudrun-build.yaml ./CaiCloudRun --substitutions=_REPOSITORY=${google_artifact_registry_repository.my_docker_repo.name},_DOCKER_IMG=${var.cai_docker_image},_PROJECTID=${var.project}"
  }

  lifecycle {
    replace_triggered_by = [
      google_cloud_run_service.ackservice
    ]
  }
}

resource "google_project_iam_binding" "token_creator_1" {
  project = var.project
  role    = "roles/iam.serviceAccountTokenCreator"
  members = ["serviceAccount:service-${data.google_project.project.number}@serverless-robot-prod.iam.gserviceaccount.com"]
}

resource "google_project_iam_binding" "sa_agent" {
  project = var.project
  role    = "roles/run.serviceAgent"
  members = ["serviceAccount:service-${data.google_project.project.number}@serverless-robot-prod.iam.gserviceaccount.com"]
}

resource "google_project_iam_binding" "token_creator" {
  project = var.project
  role    = "roles/bigquery.admin"
  members = ["serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"]
}

# Create a Service Account
# resource "google_service_account" "docker_pusher" {

#   account_id   = "docker-pusher"
#   display_name = "Docker Container Pusher"
#   depends_on =[time_sleep.wait_60_seconds]
# }

# Give Service Account permission to push to the Artifact Registry Repository
# resource "google_artifact_registry_repository_iam_member" "docker_pusher_iam" {

#   location = google_artifact_registry_repository.my_docker_repo.location
#   repository =  google_artifact_registry_repository.my_docker_repo.repository_id
#   role   = "roles/artifactregistry.writer"
#   member = "serviceAccount:${google_service_account.docker_pusher.email}"
#   depends_on = [
#     google_artifact_registry_repository.my_docker_repo, 
#     google_service_account.docker_pusher
#     ]
# }

#       Deploy API to Google Cloud Run       #
##############################################

# Deploy image to Cloud Run
resource "google_cloud_run_service" "caiservice" {
  depends_on = [null_resource.cai-docker-image]
  name       = "cai-service-api"
  location   = var.region
  template {
    spec {
      containers {
        # Retain this alternative as a contingency
        # image = "gcr.io/cai-feed2pubsub-cloudrun/caiserviceimage"
        image = "${var.region}-docker.pkg.dev/${var.project}/${var.cai_repository}/${var.cai_docker_image}"
        # image = "europe-west4-docker.pkg.dev/${var.project_id}/${var.repository}/${var.docker_image}"
        resources {
          limits = {
            "memory" = "1G"
            "cpu"    = "1"
          }
        }
      }
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale" = "1"
        "autoscaling.knative.dev/maxScale" = "1"
      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
  lifecycle {
    replace_triggered_by = [
      null_resource.cai-docker-image
    ]
    ignore_changes = [
      template.0.metadata.0.labels
    ]
  }
}

# Deploy ack cloudrun image to Cloud Run
resource "google_cloud_run_service" "ackservice" {
  depends_on = [null_resource.ack-docker-image, google_project_iam_binding.sa_agent, google_project_iam_binding.token_creator_1]
  name       = "ack-service-api"
  location   = var.region
  template {
    spec {
      containers {
        # Retain this alternative as a contingency
        # image = "gcr.io/cai-feed2pubsub-cloudrun/caiserviceimage"
        image = "${var.region}-docker.pkg.dev/${var.project}/${var.ack_repository}/${var.ack_docker_image}"
        resources {
          limits = {
            "memory" = "1G"
            "cpu"    = "1"
          }
        }
      }
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale" = "1"
        "autoscaling.knative.dev/maxScale" = "1"
      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
  lifecycle {
    ignore_changes = [
      template.0.metadata.0.labels
    ]
  }
}

# # Create a policy that allows all users to invoke the API
# data "google_iam_policy" "noauth" {
#   binding {
#     role = "roles/run.invoker"
#     members = [
#       "allUsers",
#     ]
#   }
# }

# # Apply the no-authentication policy to our Cloud Run Service.
# resource "google_cloud_run_service_iam_policy" "noauth" {
#   location    = var.region
#   project     = var.project
#   service     = google_cloud_run_service.caiservice.name

#   policy_data = data.google_iam_policy.noauth.policy_data
# }

# output "cloud_run_instance_url" {
#   value = google_cloud_run_service.caiservice.status.0.url
# }



resource "google_cloud_run_service_iam_binding" "noauth" {
  location = google_cloud_run_service.caiservice.location
  service  = google_cloud_run_service.caiservice.name
  role     = "roles/run.invoker"
  members = [
    "allUsers"
  ]
  lifecycle {
    replace_triggered_by = [
      google_cloud_run_service.caiservice
    ]
  }
}

resource "google_cloud_run_service_iam_binding" "noauth1" {
  location = google_cloud_run_service.ackservice.location
  service  = google_cloud_run_service.ackservice.name
  role     = "roles/run.invoker"
  members = [
    "allUsers"
  ]
  lifecycle {
    replace_triggered_by = [
      google_cloud_run_service.ackservice
    ]
  }
}


#               PubSub Topic                #
#############################################


resource "google_pubsub_topic" "cai-project-default" {
  name = "cai-feed-pubsub_topic"
}


# Service Account to represent PubSub subscription identity
resource "google_service_account" "sa" {
  account_id   = "cloud-run-pubsub-invoker"
  display_name = "Cloud Run Pub/Sub Invoker"
}


# Create PubSub subscription with the specified identity

# # a. give invoker service account permission to invoke the CloudRun service
# resource "google_cloud_run_service_iam_binding" "binding" {
#   location = google_cloud_run_service.caiservice.location
#   service  = google_cloud_run_service.caiservice.name
#   role     = "roles/run.invoker"
#   members  = ["serviceAccount:${google_service_account.sa.email}"]
# }

# b. Alow PubSub to create auth tokens in the project - So that the code runs for all projects prior to 2021 Apr 8
resource "google_project_service_identity" "pubsub_agent" {
  provider = google-beta
  project  = var.project
  service  = "pubsub.googleapis.com"
}

resource "google_project_iam_binding" "project_token_creator" {
  project = var.project
  role    = "roles/iam.serviceAccountTokenCreator"
  members = ["serviceAccount:${google_project_service_identity.pubsub_agent.email}"]
}

# c. Create PubSub subscription with service account
resource "google_pubsub_subscription" "subscription" {
  name  = "pubsub_subscription"
  topic = google_pubsub_topic.cai-project-default.name
  push_config {
    push_endpoint = google_cloud_run_service.caiservice.status[0].url
    oidc_token {
      service_account_email = google_service_account.sa.email
    }
    attributes = {
      x-goog-version = "v1"
    }
  }
  depends_on = [google_cloud_run_service.caiservice]
}

#                  CAI Feed                 #
#############################################

# Create a feed that sends notifications about all resource updates.
resource "google_cloud_asset_project_feed" "project_feed" {
  project      = var.project
  feed_id      = "caifeed-${google_pubsub_topic.cai-project-default.name}"
  content_type = "RESOURCE"

  asset_types = [
    ".*.googleapis.com.*",
  ]

  feed_output_config {
    pubsub_destination {
      topic = "projects/${var.project}/topics/${google_pubsub_topic.cai-project-default.name}"
    }
  }

  condition {
    expression  = <<-EOT
    temporal_asset.deleted ||
    temporal_asset.prior_asset_state == google.cloud.asset.v1.TemporalAsset.PriorAssetState.DOES_NOT_EXIST
    EOT
    title       = "critical events filter"
    description = "Send notifications on critical events for all resources"
  }
}
