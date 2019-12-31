resource "kubernetes_role" "deployment" {
  count = var.enabled_rbac_binding ? 1 : 0

  metadata {
    name = module.label.id

    labels = {
      namespace = kubernetes_namespace.namespace.metadata.0.name
      stage     = var.stage
      type      = "apps"
    }
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "services", "endpoints", "secrets", "configmaps"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["extensions"]
    resources  = ["ingresses"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["extensions"]
    resources  = ["ingresses/status"]
    verbs      = ["update"]
  }
}

resource "kubernetes_role_binding" "sa_binding" {
  count = var.enabled_rbac_binding ? 1 : 0

  metadata {
    name      = "apps-sa-binding"
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }

  role_ref {
    name      = kubernetes_role.deployment[0].metadata.0.name
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.namespace[0].metadata.0.name
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }
}
