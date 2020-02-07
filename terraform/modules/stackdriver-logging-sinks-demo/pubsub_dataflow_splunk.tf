////  create resources needed for dataflow pubsub-splunk job

// Random string used to create a unique bucket name
resource "random_id" "server-temp" {
  byte_length = 8
}

// Create a Cloud Storage Bucket for temp storage of dataflow job
resource "google_storage_bucket" "dataflow-temp-bucket" {
  name          = "dataflow-temp-storage-${random_id.server-temp.hex}"
  storage_class = "STANDARD"
  force_destroy = true
}

resource "google_pubsub_topic" "stackdriver-logging-dead-letter-topic" {
  name = "stackdriver-logging-dead-letter-topic"
}

// dataflow job to ingest pubsub logs and send them to splunk HEC
resource "google_dataflow_job" "pubsub-splunk-job" {
  name              = "pubsub-splunk-job"
  template_gcs_path = var.dataflow_template_gcs_path
  temp_gcs_location = "${google_storage_bucket.dataflow-temp-bucket.url}/temp"
  parameters = {
    inputSubscription = google_pubsub_subscription.splunk.path
    token             = var.splunk_hec_token
    url               = var.splunk_hec_url
    // outputDeadletterTopic        = "projects/sada-ala-radaoui/topics/dead-letter"
    outputDeadletterTopic        = "projects/${var.project}/topics/${google_pubsub_topic.stackdriver-logging-dead-letter-topic.name}"
    disableCertificateValidation = "true"
  }
}
