locals {
  rbac_roles = concat(var.roles, local.service_accounts_roles)
}

resource "kubernetes_role" "extra_roles" {
  count = length(local.rbac_roles)

  metadata {
    name      = lookup(local.rbac_roles[count.index], "name", "default")
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }

  dynamic "rule" {
    for_each = lookup(local.rbac_roles[count.index], "rules", [])

    content {
      api_groups = rule.value.api_groups
      resources  = rule.value.resources
      verbs      = rule.value.verbs
    }
  }
}

resource "kubernetes_role_binding" "extra_binding" {
  count = length(local.rbac_roles)

  metadata {
    name      = lookup(local.rbac_roles[count.index], "name", "default")
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }

  role_ref {
    name      = element(kubernetes_role.extra_roles.*.metadata.0.name, count.index)
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
  }

  dynamic "subject" {
    for_each = lookup(local.rbac_roles[count.index], "groups", [])

    content {
      kind      = "Group"
      name      = subject.value
      api_group = "rbac.authorization.k8s.io"
    }
  }

  dynamic "subject" {
    for_each = lookup(local.rbac_roles[count.index], "users", [])

    content {
      kind      = "User"
      name      = subject.value
      api_group = "rbac.authorization.k8s.io"
    }
  }

  dynamic "subject" {
    for_each = lookup(local.rbac_roles[count.index], "service_accounts", [])

    content {
      kind      = "ServiceAccount"
      name      = subject.value
      namespace = kubernetes_namespace.namespace.metadata.0.name
    }
  }
}
