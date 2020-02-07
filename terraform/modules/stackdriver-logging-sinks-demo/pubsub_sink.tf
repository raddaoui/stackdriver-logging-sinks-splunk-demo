// Create a PubSub topic for queuing of logs
resource "google_pubsub_topic" "stackdriver-logging-topic" {
  name = "stackdriver-logging-topic"
}

// create a subscription for the pubsub topic
resource "google_pubsub_subscription" "splunk" {
  name  = "splunk-subscriber"
  topic = google_pubsub_topic.stackdriver-logging-topic.name
}

// Create a Stackdriver Export Sink for PubSub on the project level
resource "google_logging_project_sink" "project-pubsub-sink" {
  name        = "project-pubsub-sink"
  destination = "pubsub.googleapis.com/projects/${var.project}/topics/${google_pubsub_topic.stackdriver-logging-topic.name}"
  filter      = var.logs_filter

  # Use a unique writer (creates a unique service account used for writing)
  unique_writer_identity = "true"
}

// To enable writing to the export sink we must grant permissions to sink log writer SA
// Grant the role of pubsub publisher
resource "google_pubsub_topic_iam_binding" "log-writer-pubsub" {
  topic = "projects/${var.project}/topics/${google_pubsub_topic.stackdriver-logging-topic.name}"
  role  = "roles/pubsub.publisher"
  members = [
    google_logging_project_sink.project-pubsub-sink.writer_identity,
  ]
}
