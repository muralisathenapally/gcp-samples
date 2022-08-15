data "archive_file" "source" {
  type        = "zip"
  source_dir  = "../../modules/src"
  output_path = "/tmp/function-source.zip"
}

# Create bucket that will host the source code
resource "google_storage_bucket" "bucket" {
  name     = "${var.project_id}-function"
  location = "US"
}

# Add source code zip to bucket
resource "google_storage_bucket_object" "zip" {
  name   = "source.zip"
  bucket = google_storage_bucket.bucket.name
  source = data.archive_file.source.output_path
}

resource "google_cloudfunctions_function" "function" {
  name                  = "${var.project_id}-secret-manager"
  runtime               = "python38"
  region                = "us-east4"
  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.zip.name
  entry_point           = "process_pubsub_event"
  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.topic.id
  }
}
