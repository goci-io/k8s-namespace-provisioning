resource "kubernetes_role" "deployment" {
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

resource "kubernetes_role_binding" "example" {
  metadata {
    name      = module.label.id
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }

  role_ref {
    name      = kubernetes_role.deployment.metadata.0.name
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "${module.label.id}-apps"
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }
}