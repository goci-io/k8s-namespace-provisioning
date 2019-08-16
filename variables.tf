variable "region" {
  default     = "eu-central-1"
  description = "The region to create resources in"
}

variable "namespace" {
  description = "The namespace or overall product"
}

variable "environment" {
  default     = "staging"
  description = "Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
}

variable "stage" {
  default     = "staging"
  description = "Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release'"
}

variable "name" {
  description = "Solution name, e.g. 'app' or 'jenkins'"
}

variable "annotations" {
  type        = "map"
  default     = {}
  description = "Additional annotations to attach to the namespace (eg: to allow certain kiam roles to be assumed)"
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes of the label"
}

variable "image_pull_secrets" {
  type        = "map"
  default     = {}
  description = "Pull secrets to provide to the service account to fetch docker images"
}


variable "max_pv_claims" {
  description = "Maximum amount of PersistentVolumeClaims which can be claimed within this namespace"
}

variable "max_deployments" {
  description = "Maximum amount of Deployments allowed in this namespace"
}

variable "max_jobs" {
  description = "Maximum amount of Jobs allowed in this namespace"
}

variable "max_pods" {
  description = "Maximum amount of in parallel running pods in this namespace"
}

variable "max_cpu" {
  description = "Maximum CPU allocation possible per container in this namespace"
}

variable "max_memory" {
  description = "Maximum amount of memory usage per container in this namespace"
}

variable "max_storage" {
  description = "Maximum amount of storage per persistent volume claim"
}
