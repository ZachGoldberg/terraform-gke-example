provider "google" {
  project = var.project
  region  = var.region
}


resource "google_storage_bucket" "bucket" {
  project       = var.project
  name          = "${var.project}-test-bucket"
  location      = "US"
  force_destroy = true
}

resource "google_storage_bucket_object" "object" {
  name    = "test-object"
  bucket  = google_storage_bucket.bucket.name
  content = "test"
}

