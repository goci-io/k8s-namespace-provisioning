# k8s-namespace-provisioning

#### Maintained by [@goci-io/prp-terraform](https://github.com/orgs/goci-io/teams/prp-terraform)

![terraform](https://github.com/goci-io/k8s-namespace-provisioning/workflows/terraform/badge.svg?branch=master)

This Terraform Module provisions a ready to use [Kubernetes Namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/) with Docker Registry Secrets, Resource-Quotas and Limit Ranges, as well as additional Service Accounts, Roles and RoleBindings. You can also restrict Ingress- and Egress Traffic to and from Namespaces as well as CIDRs. It can also allow Access to your [Pod Security Policies](#pod-security-policy)

### Usage

Look into the [terraform.tfvars](terraform.tfvars.example) example file or find more variables in the [variables.tf](variables.tf).

```hcl
module "namespace" {
  source     = "git::https://github.com/goci-io/k8s-namespace-provisioning.git?ref=tags/<latest-version>"
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

### Pod Security Policy

[Pod Security Policies](https://kubernetes.io/docs/concepts/policy/pod-security-policy/) can be used to add an additional Layer of Security to your Namespaces, preventing unauthorized people to create Pods with dangerous settings. This module does **not** create a Pod Security Policy for you as it is a global Cluster Resource.
You need to provide a non empty value to `pod_security_policy_name` to enable PSP Permissions. 

By default we allow `system:serviceaccounts:<namespace>` to use the PSP which enables for example default Service Accounts in your Namespace, created for your Deployments to create Pods matching the criterias specified in your PSP. If you want to allow for example humans creating Pods you will need to specify corresponding RBAC policies using `roles` variable which creates a Role and RoleBinding.

### Network Policies

Network Policies can restrict In- and Outbound Traffic. This is really useful in Multi-Tenant Clusters or in Situations where you dont fully Trust a specific Namespace. To setup Network Policies you need to enable `enable_network_policies` (true).

The following Options are available when configuring Network Policies:

`network_policy_type` (Ingress, Egress)  
`network_deny_all_policy` (true)  
`network_egress_namespaces`, `network_egress_ip_blocks`, `network_egress_ports`   
`network_ingress_namespaces`, `network_ingress_ip_blocks`, `network_ingress_ports`   

Example:

```hcl
module "namespace" {
  ...
  enable_network_policies    = true
  network_egress_ip_blocks   = ["0.0.0.0/0"]
  network_egress_namespaces  = [{ someLabel = "value" }]
  network_ingress_namespaces = [{ someLabel = "value" }]
}
```

This would allow the Namespace to talk to the Internet and a Namespace labeled with `someLabel` containing `value`.
Additionally it allows Namespaces with a Label of `someLabel=value` to send Traffic to your Namespace.

**Note:** Namespace Restrictions apply on **Labels**, not on Namespace Fields!

### Context

This module is used at [goci.io](https://goci.io) to provision Kubernetes Namespaces for our Customers.
