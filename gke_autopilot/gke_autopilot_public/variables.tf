
variable "project" {
  description = "GCP Project ID"
}

variable "region" {}

variable "google_service_account" {}

variable "name" {
  description = "The VPC Name"
}

variable "namespace" {
  default = "default"
}
