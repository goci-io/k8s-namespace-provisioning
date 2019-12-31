# k8s-namespace-provisioning

#### Maintained by [@goci-io/prp-terraform](https://github.com/orgs/goci-io/teams/prp-terraform)

This terraform module provisions a ready to use namespace with docker registry secrets, resource quotas and limits and limited rbac permissions.

### Usage

Look into the [terraform.tfvars](terraform.tfvars.example) example file or find more variables in the [variables.tf](variables.tf).

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

This module is not specific to a any cloud provider. Therefore please note that you are responsible to define a file with a backend configuration for terraform state. 

#### Verify

Verify the namespace by running `kubectl describe ns <namespace>-<stage>-<name>-<attributes>`

### Context

This module is used for go-ci to provision kubernetes namespaces for our customers.