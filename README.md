# IBM Secrets Manager module

Module to provision or lookup an instance of Secrets Manager on IBM Cloud. Optionally, the Secrets Manager instance can be encrypted with a root key from a KMS instance.

## Software dependencies

The module depends on the following software components:

### Command-line tools

- terraform - v13

### Terraform providers

- IBM Cloud provider >= 1.46.0

## Module dependencies

This module makes use of the output from other modules:

- Resource Group - github.com/cloud-native-toolkit/terraform-ibm-resource-group
- KMS Key - github.com/cloud-native-toolkit/terraform-ibm-kms-key
- IAM Authorization - github.com/terraform-ibm-modules/terraform-ibm-toolkit-iam-service-authorization.git
- CLI Util - github.com/cloud-native-toolkit/terraform-util-clis.git

## Example usage

[Refer test cases for more details](test/stages/stage2-secrets-manager.tf)

```hcl-terraform
terraform {
  required_providers {
    ibm = {
      source = "ibm-cloud/ibm"
    }
  }
  required_version = ">= 0.13"
}

provider "ibm" {
  ibmcloud_api_key      = var.ibmcloud_api_key
  region                = var.region
}

module "secrets-manager" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-secrets-manager"

  resource_group_name   = module.resource_group.name
  region                = var.region
  provision             = true
  private_endpoint      = false
  kms_private_endpoint  = true
  kms_enabled           = true
  kms_id                = module.kms_key.kms_id
  kms_key_crn           = module.kms_key.crn
  kms_private_url       = module.kms_key.kms_private_url
  kms_public_url        = module.kms_key.kms_public_url
  ibmcloud_api_key      = var.ibmcloud_api_key
  name_prefix           = var.name_prefix
  trial                 = true
  purge                 = false
}
```

## Input Variables

This module has the following input variables:
| Variable | Mandatory / Optional | Default Value | Description |
| -------------------------------- | --------------| ------------------ | ----------------------------------------------------------------------------- |
| resource_group_name | Mandatory | | The name of the IBM Cloud resource group where the Secrets Manager instance will be, or is, deployed |
| region | Mandatory | | The region where the Secrets Manager instance will be, or is, deployed |
| ibmcloud_api_key | Mandatory | | The IBM Cloud API Key for the build |
| provision | Optional | true | Flag to indicate whether to provision a new instance or read an existing one |
| name_prefix | Optional | "" | Name prefix for the resource. If not provided, will default to resource group name |
| name | Optional | "" | Name for the resource. If not provided will default to $name_prefix-$label |
| label | Optional | sm | Suffix for the resource name if name value not provided |
| kms_enabled | Optional | false | Flag to indicate that a KMS root key should be used for the Secrets Manager instance. If true, set the key CRN value. |
| kms_key_crn | Optional | null | CRN for the KMS key to use as the root key for the Secrets Manager. Only used if kms_enabled is set true |
| private_endpoint | Optional | false | Flag to indicate that the service should be provisioned on private endpoint only, no public endpoint |
| create_auth | Optional | true | Flag to indicate that a service authorization should be created to allow the Secrets Manager to access the KMS and HPCS services to read keys |
| trial | Optional | false | Flag to indicate whether to use a trial (false) or standard (false) plan |
| purge | Optional | false | Flag to indicate whether to purge the resource from reclamation after being destroyed. Note that this will permanently remove the resource and prevent recovery of secrets. Not recommended for production deployments. |

## Outputs


The module outputs the following values:
| Output | Description |
| -------------------------------- | -------------------------------------------------------------------------- |
| id | The CRN id of the Secrets Manager instance |
| guid | The guid of the Secrets Manager instance |
| name | The name of the Secrets Manager instance |
| crn | The CRN id of the Secrets Manager instance |
| location | The region of the Secrets Manager instance |
| service | The name of the service provisioned for the Secrets Manager instance |
| plan | The plan of the provisioned service |

