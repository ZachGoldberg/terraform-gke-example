

module "autopilot_cluster" {
  source  = "./gke_autopilot_public"
  name    = "test-autopilot-cluster"
  project = var.project
  region  = var.region

  google_service_account = var.google_service_account
}
