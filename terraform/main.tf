locals {
  project = "{{ put projectID }}"
  zone    = "us-central1-a"
  // filter admin activity audit logs for k8s clusters and gce instances
  logs_filter = "logName:cloudaudit.googleapis.com%2Factivity AND (resource.type=gce_instance OR resource.type=k8s_cluster)"
  dataflow_template_gcs_path = "gs://dataflow-templates-us-central1/latest/Cloud_PubSub_to_Splunk"
  splunk_hec_token = "{{ put splunk hec token }}"
  splunk_hec_url = "{{put splunk hec url}}"  // example splunk hec url http://splunk_server_ip:8088
}

module "stackdriver-logging-sinks-demo" {
  source = "./modules/stackdriver-logging-sinks-demo"

  project                    = "${local.project}"
  zone                       = "${local.zone}"
  logs_filter                = "${local.logs_filter}"
  dataflow_template_gcs_path = "${local.dataflow_template_gcs_path}"
  splunk_hec_token           = "${local.splunk_hec_token}"
  splunk_hec_url             = "${local.splunk_hec_url}"
}
