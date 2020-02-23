
variable "namespace" {
  default     = ""
  description = "The organizations prefix or namespace"
}

variable "stage" {
  default     = ""
  description = "Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release'"
}

variable "environment" {
  default     = ""
  description = "Additional environment label. Eg if stage does not match the environment"
}

variable "name" {
  description = "Solution name, e.g. 'app' or 'jenkins'"
}

variable "annotations" {
  type        = map(string)
  default     = {}
  description = "Additional annotations to attach to the namespace (eg: to allow certain kiam roles to be assumed)"
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = "Labels to attach to the kubernetes namespace"
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes of the label"
}

variable "image_pull_secrets" {
  type        = map
  default     = {}
  description = "Pull secrets to provide to the service account to fetch docker images"
}

variable "enabled_rbac_binding" {
  type        = bool
  default     = true
  description = "Deploys additional RBAC role binding to a service account named like the namespace (+-apps)"
}

variable "max_pv_claims" {
  type        = number
  default     = 30
  description = "Maximum amount of PersistentVolumeClaims which can be claimed within this namespace"
}

variable "max_deployments" {
  type        = number
  default     = 100
  description = "Maximum amount of Deployments allowed in this namespace"
}

variable "max_jobs" {
  type        = number
  description = "Maximum amount of Jobs allowed in this namespace"
}

variable "max_pods" {
  type        = number
  default     = 2500
  description = "Maximum amount of in parallel running pods in this namespace"
}

variable "max_cpu" {
  type        = string
  description = "Maximum CPU allocation possible per container in this namespace"
}

variable "max_memory" {
  type        = string
  description = "Maximum amount of memory usage per container in this namespace"
}

variable "max_storage" {
  type        = string
  default     = "500Gi"
  description = "Maximum amount of storage per persistent volume claim"
}

variable "max_load_balancers" {
  type        = number
  default     = 1
  description = "Maximum amount of services with type LoadBalancer"
}

variable "max_node_ports" {
  type        = number
  default     = 0
  description = "Maximum amount of services with type NodePort"
}

variable "enable_network_policies" {
  type        = bool
  default     = true
  description = "Deploys additional kubernetes network policies for the namespace created"
}

variable "http_egress_namespaces" {
  type        = list(string)
  default     = ["default", "cluster"]
  description = "Namespaces to allow egress traffic to"
}

variable "http_egress_ip_blocks" {
  type        = list(string)
  default     = []
  description = "IP Blocks to allow egress traffic to. Could be a NAT Gateway IP /32 to allow only Internet Traffic"
}

variable "http_ingress_namespaces" {
  type        = list(string)
  default     = ["cluster"]
  description = "Namespaces to allow ingress traffic from"
}
