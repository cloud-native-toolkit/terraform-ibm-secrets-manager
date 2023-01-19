module "secrets-manager" {
  source = "./module"

  resource_group_name = module.resource_group.name
  region = var.region
  provision = true
  private_endpoint = false
  kms_private_endpoint = true
  kms_enabled = true
  kms_key_crn = module.kms_key.crn
  ibmcloud_api_key = var.ibmcloud_api_key
  name_prefix = var.name_prefix
  trial = true
}
