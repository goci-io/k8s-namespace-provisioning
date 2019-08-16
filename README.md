# k8s-namespace-provisioning

This terraform module provisions a ready to use namespace with docker registry secrets, resource quotas and limits and limited rbac permissions.


### Usage

Look into the [terraform.tfvars](terraform.tfvars.example) example file.

```hcl
module "label" {
  source     = "git::https://github.com/goci-io/k8s-namespace-provisioning.git?ref=master"
  namespace  = "goci"
  stage      = "staging"
  attributes = ["team"]
  name       = "sub-org"
  max_cpu    = "600m"
  max_memory = "728Mi"
  max_pods   = 50 // hard limit
  image_pull_secrets = {
    "secret-1" = "docker config file",
    "secret-2" = "docker config file"
  }
}
```

#### Verify

Verify the namespace by running `kubectl describe ns <namespace>-<stage>-<name>-<attributes>`

### Context

This module is used for go-ci to provision kubernetes namespaces for our customers.