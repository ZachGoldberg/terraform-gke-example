

module "standard_cluster" {
  source  = "./gke_public"
  name    = "test-standard-cluster"
  project = var.project
  region  = var.region

  google_service_account = var.google_service_account
}
