
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
      "persistentvolumeclaims" = var.max_pv_claims
      "count/jobs.batch"             = var.max_jobs
      "count/deployments.apps"       = var.max_deployments
      "count/services.loadbalancers" = 0
      "count/services.nodeports"     = 0
    }
  }
}
