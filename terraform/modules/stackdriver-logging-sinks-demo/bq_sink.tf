// Create a BigQuery Dataset for storage of logs
// Note: only the most recent hour's data will be stored based on the table expiration
resource "google_bigquery_dataset" "stackdriver-bigquery-dataset" {
  dataset_id                  = "stackdriver_logs_dataset"
  location                    = "US"
  default_table_expiration_ms = 3600000
  delete_contents_on_destroy  = true

  labels = {
    env = "default"
  }
}

// Create a Stackdriver Export Sink for BigQuery on the project level
resource "google_logging_project_sink" "project-bigquery-sink" {
  name        = "project-bigquery-sink"
  destination = "bigquery.googleapis.com/projects/${var.project}/datasets/${google_bigquery_dataset.stackdriver-bigquery-dataset.dataset_id}"
  filter      = var.logs_filter

  unique_writer_identity = true
}

// To enable writing to the export sink we must grant permissions for sink log writer SA
// Grant the role of BigQuery Data Editor
resource "google_project_iam_binding" "log-writer-bigquery" {
  role = "roles/bigquery.dataEditor"

  members = [
    google_logging_project_sink.project-bigquery-sink.writer_identity,
  ]
}
