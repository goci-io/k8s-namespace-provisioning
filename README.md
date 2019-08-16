# k8s-namespace-provisioning

This terraform module provisions a ready to use namespace with docker registry secrets, resource quotas and limits and limited rbac permissions.


### Usage

Look into the [terraform.tfvars](terraform.tfvars.example) example file.

### Context

This module is used for go-ci to provision kubernetes namespaces for our customers.