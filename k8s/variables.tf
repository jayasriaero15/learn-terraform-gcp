variable "project_id" {
  type        = string
  description = "Default project_id for this module"
  default     = "project-af5a9a8c-a838-417b-891"
}

variable "region" {
  type        = string
  description = "Default region for this module"
  default     = "asia-south2"
}

variable "zone" {
  type        = string
  description = "Default zone for this module"
  default     = "asia-south2-a"
}

variable "peer_network_b" {
  type    = string
  default = "Self Link of VPC B"
}
