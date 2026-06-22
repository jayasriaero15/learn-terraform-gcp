variable "project_id" {
  type        = string
  description = "default project id"
  default     = "iam-test-project-499205"
}

variable "region" {
  type        = string
  description = "default region"
  default     = "asia-south2"
}

variable "zone" {
  type        = string
  description = "default zone"
  default     = "asia-south2-a"
}

variable "peer_network_a" {
  description = "Self Link of VPC A"
  type        = string
}
