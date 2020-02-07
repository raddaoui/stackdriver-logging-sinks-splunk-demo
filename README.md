# Logging with Stackdriver

## Introduction

This repo presents a quick demonstration of the different options to export stackdriver logs. It also provides an example dataflow job to send your logs to splunk for further analysis

## Prerequisites

The steps described in this document require the installation of several tools and the proper configuration of authentication to allow them to access your GCP resources.

### Cloud Project

You'll need access to a Google Cloud Project with billing enabled. See **Creating and Managing Projects** (https://cloud.google.com/resource-manager/docs/creating-managing-projects) for creating a new project.

### Tools
1. [Terraform >= 0.12](https://www.terraform.io/downloads.html)
2. [Google Cloud SDK version >= 204.0.0](https://cloud.google.com/sdk/docs/downloads-versioned-archives)

### Configure Authentication

The Terraform configuration will execute against your GCP environment and create various resources.  To setup the default account the script will use, run the following command to select the appropriate account:

```console
gcloud auth application-default login`
```

### Deploy resources

1. Clone repo and move into the terraform folder

```console
git clone git@github.com:raddaoui/stackdriver-logging-sinks-splunk-demo.git && cd stackdriver-logging-sinks-splunk-demo/terraform
```

2. Open the main.tf and edit the locals to match your environment

```console
vi main.tf
```

3. Run the terraform

```console
terraform init && terraform apply -auto-approve
```

### Teardown

When you are finished with this example you will want to clean up the resources that were created so that you avoid accruing charges:

```console
terraform destroy -auto-approve
```
