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

# State bucket is managed externally (created manually)
# This follows best practices and avoids circular dependency issues
# Run setup-backend.sh once before using this Terraform configuration
