variable "resource_group_name" {
  type        = string
  description = "The name of the IBM Cloud resource group where the Secrets Manager instance will be/has been provisioned."
}

variable "region" {
  description = "The region where the Secrets Manager will be/has been provisioned."
  type        = string
}

variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud api key"
  sensitive   = true
  default     = ""
}

variable "provision" {
  description = "Flag indicating that the instance should be provisioned. If false then an existing instance will be looked up"
  type        = bool
  default     = true
}

variable "kms_enabled" {
  type        = bool
  description = "Flag indicating that kms encryption should be enabled for this instance"
  default     = false
}

variable "kms_private_endpoint" {
  type        = bool
  description = "Flag indicating the KMS private endpoint should be used"
  default     = true
}

variable "kms_key_crn" {
  type        = string
  description = "The crn of the root key in the KMS to encrypt secret content"
  default     = null
}

variable "name_prefix" {
  type        = string
  description = "The name prefix for the Secrets Manager resource. If not provided will default to resource group name."
  default     = ""
}

variable "name" {
  description = "Name of the Secrets Manager. If not provided will be generated as $name_prefix-$label"
  type        = string
  default     = ""
}

variable "label" {
  description = "Label used to build the Secrets Manager name if not provided."
  type        = string
  default     = "sm"
}

variable "private_endpoint" {
  type        = bool
  description = "Flag indicating that the service should be access using private endpoints"
  default     = true
}

variable "create_auth" {
  type        = bool
  description = "Flag indicating the service authorization should be created to allow this service to access the KMS service"
  default     = true
}

variable "trial" {
  type        = bool
  description = "Flag indicating whether the instance to be deployed is to be a trial plan. "
  default     = false
}