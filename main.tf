terraform {
  required_version = ">= 0.12.1"
}

provider "kubernetes" {
}

module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.15.0"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  attributes = "${var.attributes}"
  name       = "${var.name}"
  delimiter  = "-"
}
