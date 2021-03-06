resource "kubernetes_network_policy" "deny_all" {
  count = var.enable_network_policies && var.network_deny_all_policy ? 1 : 0

  metadata {
    name      = "deny-all"
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }

  spec {
    policy_types = ["Ingress", "Egress"]
    pod_selector {}
    ingress {}
  }
}

resource "kubernetes_network_policy" "allow" {
  count = var.enable_network_policies && length(var.network_policy_types) > 0 ? 1 : 0

  metadata {
    name      = "allow-custom"
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }

  spec {
    policy_types = var.network_policy_types
    pod_selector {}

    ingress {
      dynamic "ports" {
        for_each = var.network_ingress_ports

        content {
          port     = ports.value
          protocol = "TCP"
        }
      }

      from {
        pod_selector {}
      }

      dynamic "from" {
        for_each = var.network_ingress_namespaces

        content {
          namespace_selector {
            match_labels = from.value
          }
        }
      }
    }

    egress {
      to {
        pod_selector {}
      }

      dynamic "to" {
        for_each = var.network_egress_namespaces

        content {
          namespace_selector {
            match_labels = to.value
          }
        }
      }

      dynamic "to" {
        for_each = var.network_egress_ip_blocks

        content {
          ip_block {
            cidr = to.value
          }
        }
      }

      dynamic "ports" {
        for_each = var.network_egress_ports

        content {
          port     = ports.value
          protocol = "TCP"
        }
      }
    }
  }
}
