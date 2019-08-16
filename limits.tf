
resource "kubernetes_limit_range" "limits" {
  metadata {
    name      = module.label.id
    namespace = module.label.id
  }

  spec {
    limit {
      type = "PersistentVolumeClaim"

      default = {
        storage = "2Gi"
      }

      max = {
        storage = var.max_storage
      }
    }

    limit {
      type = "Container"

      default = {
        cpu    = "50m"
        memory = "64Mi"
      }

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
    namespace = module.label.id
  }

  spec {
    hard = {
      "pods"                   = var.max_pods
      "jobs.batch"             = var.max_jobs
      "persistentvolumeclaims" = var.max_pv_claims
      "deployments.apps"       = var.max_deployments
      "services.loadbalancers" = 0
      "services.nodeports"     = 0
    }
  }
}
