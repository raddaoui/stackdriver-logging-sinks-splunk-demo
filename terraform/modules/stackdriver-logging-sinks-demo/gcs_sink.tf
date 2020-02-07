// Random string used to create a unique bucket name
resource "random_id" "server" {
  byte_length = 8
}

// Create a Cloud Storage Bucket for long-term storage of logs
// Note: the bucket has force_destroy turned on, so the data will be lost if you run terraform destroy
resource "google_storage_bucket" "stackdriver-log-bucket" {
  name          = "stackdriver-logging-archive-${random_id.server.hex}"
  storage_class = "NEARLINE"
  force_destroy = true
}

// Create a Stackdriver Export Sink for Cloud Storage on the project level
resource "google_logging_project_sink" "project-storage-sink" {
  name        = "project-storage-sink"
  destination = "storage.googleapis.com/${google_storage_bucket.stackdriver-log-bucket.name}"
  filter      = var.logs_filter

  unique_writer_identity = true
}

/*
// Create a Stackdriver Export Sink for Cloud Storage on the folder level example
resource "google_logging_folder_sink" "folder-storage-sink" {
  name   = "folder-storage-sink"
  folder = "549097097303"

  # Can export to pubsub, cloud storage, or bigquery
  destination = "storage.googleapis.com/${google_storage_bucket.stackdriver-log-bucket.name}"

  filter           = var.logs_filter
  include_children = true
}*/

/*
// Create a Stackdriver Export Sink for Cloud Storage on the org level example
resource "google_logging_organization_sink" "org-storage-sink" {
  name   = "org-storage-sink"
  org_id = "123456789"

  # Can export to pubsub, cloud storage, or bigquery
  destination = "storage.googleapis.com/${google_storage_bucket.stackdriver-log-bucket.name}"

  filter           = var.logs_filter
  include_children = true

}*/


// To enable writing to the storage export sinks we must grant permissions for sink log writer SA
// Grant the role of Storage Object Creator
resource "google_project_iam_binding" "log-writer-storage" {
  role = "roles/storage.objectCreator"

  members = [
    google_logging_project_sink.project-storage-sink.writer_identity,
  ]
}
