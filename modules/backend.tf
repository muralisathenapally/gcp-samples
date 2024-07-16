terraform {
  backend "gcs" {
    bucket  = "testmybuckbuck"
    prefix  = "terraform/state"
  }
}
