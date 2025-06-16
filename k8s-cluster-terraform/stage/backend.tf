terraform {
  backend "gcs" {
    bucket = "terraform-state-k8s-stage-beaming-pillar-461818-j7"
    prefix = "terraform/state"
  }
} 