locals {
  enable_psp_binding = var.pod_security_policy_name != ""
  default_psp_groups = ["system:serviceaccounts:${kubernetes_namespace.namespace.metadata.0.name}"]
  allowed_psp_groups = length(var.pod_security_policy_groups) < 1 ? local.default_psp_groups : var.pod_security_policy_groups
}

resource "kubernetes_role" "use_psp" {
  count = local.enable_psp_binding ? 1 : 0

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
  count = local.enable_psp_binding ? 1 : 0

  metadata {
    name      = "psp-${var.pod_security_policy_name}"
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }

  role_ref {
    name      = join("", kubernetes_role.use_psp.*.metadata.0.name)
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
  }

  dynamic "subject" {
    for_each = local.allowed_psp_groups

    content {
      kind      = "Group"
      name      = subject.value
      namespace = kubernetes_namespace.namespace.metadata.0.name
    }
  }
}
