variable "project" {
  description = "name of project where to create resources"
  type        = string
}

variable "zone" {
  description = "zone where to create resources"
  type        = string
}

variable "logs_filter" {
  description = "log query to filter exported logs"
}

variable "dataflow_template_gcs_path" {
  description = "dataflow template gcs path"
  type        = string
}

variable "splunk_hec_token" {
  description = "splunk hec token"
  type        = string
}

variable "splunk_hec_url" {
  description = "splunk hec url"
  type        = string
}
