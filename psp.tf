resource "kubernetes_role" "use_psp" {
  count = var.enable_pod_security_policy ? 1 : 0

  metadata {
    name      = "psp-${var.pod_security_policy_name}"
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }

  rule {
    api_groups     = ["policy"]
    verbs          = ["use"]
    resources      = ["podsecuritypolicies"]
    resource_names = [var.pod_security_policy_name]
  }
}

resource "kubernetes_role_binding" "psp_binding" {
  count = var.enable_pod_security_policy ? 1 : 0

  metadata {
    name      = "psp-${var.pod_security_policy_name}"
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }

  role_ref {
    name      = join("", kubernetes_role.use_psp.*.metadata.0.name)
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
  }

  subject {
    kind      = "Group"
    name      = "system:authenticated"
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }
}
