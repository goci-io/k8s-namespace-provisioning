locals {
  container_cpu_default    = var.max_cpu == 0 ? {} : { cpu = "50m" }
  container_memory_default = var.max_memory == 0 ? {} : { memory = "64Mi" }
  storage_amount_default   = var.max_storage == 0 ? {} : { storage = "2Gi" }
}

resource "kubernetes_limit_range" "limits" {
  metadata {
    name      = module.label.id
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }

  spec {
    limit {
      type    = "PersistentVolumeClaim"
      default = local.storage_amount_default

      max = {
        storage = var.max_storage
      }
    }

    limit {
      type    = "Container"
      default = merge(local.container_cpu_default, local.container_memory_default)

      max = {
        cpu    = var.max_cpu
        memory = var.max_memory
      }
    }
  }
}

resource "kubernetes_resource_quota" "limits" {
  metadata {
    name      = module.label.id
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }

  spec {
    hard = {
      "pods"                         = var.max_pods
      "persistentvolumeclaims"       = var.max_pv_claims
      "count/jobs.batch"             = var.max_jobs
      "count/deployments.apps"       = var.max_deployments
      "count/services.loadbalancers" = var.max_load_balancers
      "count/services.nodeports"     = var.max_node_ports
    }
  }
}
