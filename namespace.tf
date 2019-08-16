
resource "kubernetes_namespace" "namespace" {
  metadata {
    name        = module.label.id
    annotations = var.annotations

    labels = {
      namespace = module.label.id
      stage     = var.stage
      type      = "host"
    }
  }
}
