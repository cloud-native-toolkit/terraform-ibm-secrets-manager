locals {
  prefix_name   = var.name_prefix != "" ? var.name_prefix : var.resource_group_name
  name          = lower(replace(var.name != "" ? var.name : "${local.prefix_name}-${var.label}", "_", "-"))
  service       = "secrets-manager"
  plan          = var.trial ? "trial" : "standard"
  binary_dir    = "bin"
  tmp_dir       = "tmp"
  id_file       = "sm-id"

  kms_parameters = var.kms_enabled ? {
    kms_key = var.kms_key_crn
  } : {}

  base_parameters = var.private_endpoint ? {
    allowed_network = "private-only"
  } : {}

  parameters = merge(local.base_parameters, local.kms_parameters)
}

resource null_resource print_names {
  provisioner "local-exec" {
    command = "echo 'Resource group: ${var.resource_group_name}'"
  }
}

resource null_resource print_prefix {
  provisioner "local-exec" {
    command = "echo 'Name: ${local.name}'"
  }
}

module "clis" {
  source = "github.com/cloud-native-toolkit/terraform-util-clis.git"

  clis = ["ibmcloud","jq"]
}

data ibm_resource_group resource_group {
  depends_on = [null_resource.print_names]

  name = var.resource_group_name
}

module "kms_auth" {
  count = var.kms_enabled && var.create_auth ? 1 : 0
  source = "github.com/terraform-ibm-modules/terraform-ibm-toolkit-iam-service-authorization.git?ref=v1.2.13"

  ibmcloud_api_key    = var.ibmcloud_api_key
  source_service_name = local.service
  target_service_name = "kms"
  roles = ["Reader"]
}

module "hpcs_auth" {
  count = var.kms_enabled && var.create_auth ? 1 : 0
  source = "github.com/terraform-ibm-modules/terraform-ibm-toolkit-iam-service-authorization.git?ref=v1.2.13"

  ibmcloud_api_key    = var.ibmcloud_api_key
  source_service_name = local.service
  target_service_name = "hs-crypto"
  roles = ["Reader"]
}

resource "ibm_resource_instance" "secrets-manager" {
  count = var.provision ? 1 : 0
  
  depends_on = [
    module.kms_auth,
    module.hpcs_auth,
    null_resource.purge-sm
  ]

  name              = local.name
  service           = local.service
  plan              = local.plan
  location          = var.region
  parameters        = local.parameters
  resource_group_id = data.ibm_resource_group.resource_group.id
  timeouts {
    create = "30m"
    update = "15m"
    delete = "15m"
  }
}

data "ibm_resource_instance" "secrets-manager" {
  depends_on        = [ibm_resource_instance.secrets-manager]

  name              = local.name
  resource_group_id = data.ibm_resource_group.resource_group.id
  location          = var.region
  service           = local.service
}

resource "null_resource" "note-sm-id" {
  count = var.purge ? 1 : 0
  depends_on = [
    ibm_resource_instance.secrets-manager,
    null_resource.purge-sm
  ]

  triggers = {
    id        = data.ibm_resource_instance.secrets-manager.guid
    path      = "${path.cwd}/${local.tmp_dir}"
    filename  = local.id_file
  }

  provisioner "local-exec" {
    when = destroy
    command = "${path.module}/scripts/write-id.sh ${self.triggers.id} ${self.triggers.path} ${self.triggers.filename}"
  }
}

resource "null_resource" "purge-sm" {
  count = var.purge ? 1 : 0

  depends_on = [
    module.clis
  ]

  triggers = {
    filename = "${path.cwd}/${local.tmp_dir}/${local.id_file}"
    apikey    = var.ibmcloud_api_key
  }

  provisioner "local-exec" {
    when = destroy
    command = "${path.module}/scripts/purge-instance.sh ${self.triggers.filename}"

    environment = {
      IBMCLOUD_API_KEY = self.triggers.apikey
     }
  }
}