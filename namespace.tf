
resource "kubernetes_namespace" "namespace" {
  metadata {
    name        = module.label.id
    annotations = var.annotations
    labels      = var.labels
  }
}
