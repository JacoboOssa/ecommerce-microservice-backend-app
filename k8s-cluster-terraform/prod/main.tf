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

resource "random_id" "default" {
  byte_length = 8
}

resource "google_storage_bucket" "default" {
  name     = "${random_id.default.hex}-terraform-remote-backend"
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

  # Uncomment this to prevent accidental deletion of the state bucket
  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "local_file" "default" {
  file_permission = "0644"
  filename        = "${path.module}/backend.tf"

  content = <<-EOT
  terraform {
    backend "gcs" {
      bucket = "${google_storage_bucket.default.name}"
    }
  }
  EOT

  # Ensure the backend file is created BEFORE other resources
  # and destroyed AFTER other resources
  depends_on = [
    module.prod_cluster
  ]
}
