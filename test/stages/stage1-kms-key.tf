module "kms_key" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-kms-key"

  name_prefix      = var.name_prefix
  label            = "test-key"
  provision        = true
  kms_id           = module.key_protect.guid
  kms_public_url   = module.key_protect.public_url
  kms_private_url  = module.key_protect.private_url
}
