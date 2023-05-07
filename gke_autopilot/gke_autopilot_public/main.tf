provider "google" {
  project = var.project
  region  = var.region
}

resource "google_container_cluster" "gke" {
  name = var.name

  location = var.region
  project  = var.project

  enable_autopilot = true

  ip_allocation_policy {
    cluster_secondary_range_name  = ""
    services_secondary_range_name = ""
  }


  maintenance_policy {
    daily_maintenance_window {
      start_time = "04:00"
    }
  }
}
