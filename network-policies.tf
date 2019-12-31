
resource "kubernetes_network_policy" "deny_all" {
  count = var.enable_network_policies ? 1 : 0

  metadata {
    name      = "deny-all"
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }

  spec {
    pod_selector = {}
    ingress      = []
  }
}

resource "kubernetes_network_policy" "allow_http" {
  count = var.enable_network_policies ? 1 : 0

  metadata {
    name      = "http"
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }

  spec {
    policy_types = ["Ingress", "Egress"]
    pod_selector = {}

    ingress {
      ports {
        port     = "http"
        protocol = "TCP"
      }

      ports {
        port     = "https"
        protocol = "TCP"
      }

      dynamic "from" {
        for_each = var.http_ingress_namespaces

        content {
          namespace_selector {
            match_labels {
              name = from.value
            }
          }
        }
      }
    }

    egress {
      dynamic "to" {
        for_each = var.http_egress_namespaces

        content {
          namespace_selector {
            match_labels {
              name = to.value
            }
          }
        }
      }

      dynamic "ip_block" {
        for_each = var.http_egress_ip_blocks

        content {
          cidr = ip_block.value
        }
      }
    }
  }
}
