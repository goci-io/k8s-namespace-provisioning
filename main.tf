
module "label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  namespace   = var.namespace
  stage       = var.stage
  attributes  = var.attributes
  environment = var.environment
  name        = var.name
  delimiter   = "-"
}
