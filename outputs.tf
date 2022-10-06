output "id" {
  description = "The Secrets Manager instance CRN id"
  value       = data.ibm_resource_instance.secrets-manager.id
}

output "guid" {
  description = "The Secrets Manager instance guid"
  value       = data.ibm_resource_instance.secrets-manager.guid
}

output "name" {
  description = "The Secrets Manager instance name"
  value       = local.name
  depends_on  = [data.ibm_resource_instance.secrets-manager]
}

output "crn" {
  description = "The crn of the Secrets Manager instance"
  value       = data.ibm_resource_instance.secrets-manager.id
}

output "location" {
  description = "The Secrets Manager instance location"
  value       = var.region
  depends_on  = [data.ibm_resource_instance.secrets-manager]
}

output "service" {
  description = "The name of the service provisioned for the Secrets Manager instance"
  value       = local.service
  depends_on = [data.ibm_resource_instance.secrets-manager]
}

output "plan" {
  description = "The plan of the service provisioned"
  value       = local.plan
  depends_on = [data.ibm_resource_instance.secrets-manager]
}