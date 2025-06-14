module "prod_cluster" {
    source     = "../main"
    env_name   = "prod"
    project_id = "${var.project_id}"
    instance_type = "n2-highmem-2"
    min_count      = 3
    max_count      = 5
    cluster_name = "k8s-cluster"
}

variable "project_id" {
  description = "The project ID to host the cluster in"
  default = "beaming-pillar-461818-j7"
}

resource "google_storage_bucket" "default" {
  name     = "terraform-state-k8s-prod-${var.project_id}"
  location = "US"
  project  = var.project_id

  force_destroy               = true
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  # Ensure the bucket is destroyed AFTER all other resources
  depends_on = [
    module.prod_cluster
  ]

  # Prevent accidental deletion of the state bucket
  lifecycle {
    prevent_destroy = true
  }
}

# Backend configuration is now in backend.tf file
# No need for dynamic generation
