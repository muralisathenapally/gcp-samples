data "archive_file" "source" {
  count       = var.setup_secret_manager == "yes" ? 1 : 0
  type        = "zip"
  source_dir  = "../../modules/src"
  output_path = "/tmp/function-source.zip"
}

# Create bucket that will host the source code
resource "google_storage_bucket" "bucket" {
  count    = var.setup_secret_manager == "yes" ? 1 : 0
  name     = "${var.project_id}-function"
  location = "US"
  project  = var.project_id
}

# Add source code zip to bucket
resource "google_storage_bucket_object" "zip" {
  count  = var.setup_secret_manager == "yes" ? 1 : 0
  name   = "source.zip"
  bucket = google_storage_bucket.bucket[0].name
  source = data.archive_file.source[0].output_path
}

resource "google_cloudfunctions_function" "function" {
  depends_on            = [google_project_iam_member.cloudfunction_gcs_read]
  project               = var.project_id
  count                 = var.setup_secret_manager == "yes" ? 1 : 0
  name                  = "${var.project_id}-secret-manager"
  runtime               = "python310"
  region                = "us-east4"
  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket[0].name
  source_archive_object = google_storage_bucket_object.zip[0].name
  entry_point           = "process_pubsub_event"
  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.topic[0].id
  }
  environment_variables = {
    PROJECT = var.project_id
  }
}

resource "google_project_iam_member" "cloudfunction_gcs_read" {
  project = data.google_project.project.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}
