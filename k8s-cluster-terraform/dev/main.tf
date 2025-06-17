module "dev_cluster" {
    source     = "../main"
    env_name   = "dev"
    project_id = "${var.project_id}"
    instance_type = "e2-small"
    min_count      = 1
    max_count      = 2
    cluster_name = "k8s-cluster"
}

variable "project_id" {
  description = "The project ID to host the cluster in"
  default = "beaming-pillar-461818-j7"
}

# State bucket is managed externally (created manually)
# This follows best practices and avoids circular dependency issues
# Run setup-backend.sh once before using this Terraform configuration 