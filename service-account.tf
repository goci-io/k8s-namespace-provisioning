resource "kubernetes_service_account" "users" {
  count = length(var.service_accounts)

  metadata {
    name      = lookup(var.service_accounts[count.index], "name", "default")
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }

  dynamic "image_pull_secret" {
    for_each = lookup(var.service_accounts[count.index], "image_pull_secrets", [])

    content {
      name = image_pull_secret.key
    }
  }
}

resource "kubernetes_role" "service_accounts" {
  count = length(var.service_accounts)

  metadata {
    name      = lookup(var.service_accounts[count.index], "name", "default")
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }

  dynamic "rule" {
    for_each = lookup(var.service_accounts[count.index], "rules", [])

    content {
      api_groups = rule.value.api_groups
      resources  = rule.value.resources
      verbs      = rule.value.verbs
    }
  }
}

resource "kubernetes_role_binding" "sa_binding" {
  count = length(var.service_accounts)

  metadata {
    name      = lookup(var.service_accounts[count.index], "name", "default")
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }

  role_ref {
    name      = element(kubernetes_role.service_accounts.*.metadata.0.name, count.index)
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
  }

  subject {
    kind      = "ServiceAccount"
    name      = element(kubernetes_service_account.users.*.metadata.0.name, count.index)
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }
}

locals {
  pull_secret_keys = keys(var.image_pull_secrets)
}

resource "kubernetes_secret" "image_pull" {
  count = length(local.pull_secret_keys)
  type  = "kubernetes.io/dockerconfigjson"

  metadata {
    name      = element(local.pull_secret_keys, count.index)
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }

  data = {
    ".dockerconfigjson" = lookup(var.image_pull_secrets, element(local.pull_secret_keys, count.index))
  }
}
