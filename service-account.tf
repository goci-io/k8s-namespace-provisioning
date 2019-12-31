
locals {
  pull_secret_keys = keys(var.image_pull_secrets)
}

resource "kubernetes_service_account" "namespace" {
  count = var.enabled_rbac_binding ? 1 : 0

  metadata {
    name      = "${module.label.id}-apps"
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }

  dynamic "image_pull_secret" {
    for_each = var.image_pull_secrets

    content {
      name = image_pull_secret.key
    }
  }
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
