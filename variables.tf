variable "cluster_name" {
  type        = string
  default     = "snaptrude-DEV"
  description = "A name for the EKS cluster, and the resources it depends on"
}

variable "cidr_block" {
  type        = string
  default     = "10.5.0.0/16"
  description = "The CIDR block for the VPC that EKS will run in"
}

variable "availability_zones" {
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  description = "The availability zones to launch worker nodes in"
}

variable "cluster_names" {
  description = "Names of the EKS clusters deployed in this VPC."
  type        = list(string)
  default     = []
}

variable "aws_auth_role_map" {
  default     = []
  description = "A list of mappings from aws role arns to kubernetes users, and their groups"
}

variable "aws_auth_user_map" {
  default     = []
  description = "A list of mappings from aws user arns to kubernetes users, and their groups"
}

variable "envelope_encryption_enabled" {
  type        = bool
  default     = true
  description = "Should Cluster Envelope Encryption be enabled, if changed after provisioning - forces the cluster to be recreated"
}

