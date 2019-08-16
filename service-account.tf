
locals {
  pull_secret_keys = keys(var.image_pull_secrets)
}

resource "kubernetes_service_account" "namespace" {
  metadata {
    name      = "${module.label.id}-apps"
    namespace = module.label.id
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
    namespace = module.label.id
  }

  data = {
    ".dockerconfigjson" = lookup(var.image_pull_secrets, element(local.pull_secret_keys, count.index))
  }
}
