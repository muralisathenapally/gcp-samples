provider "google" {
  credentials      = "key.json"
}
resource "google_storage_bucket" "auto-expire" {
  name          = "ms-no-public-access-bucket"
  location      = "US"
  force_destroy = true
  project = "psyched-circuit-405312"
}
