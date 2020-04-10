/*-------------------------------------------------------*/
variable "namespace" {
}
variable "env" {
}
variable "subnet_ids" {
  type = list(string)
}
/*-------------------------------------------------------*/
variable "replication_group_id" {
}
variable "redis_node_type" {
}
variable "redis_port" {
}
variable "redis_parameter_group_name" {
}
variable "redis_version" {
}
variable "redis_snapshot_retention_limit" {
}
variable "redis_maintenance_window" {
}
variable "redis_snapshot_window" {
}
variable "transit_encryption_enabled" {
}
variable "at_rest_encryption_enabled"{
}
variable "automatic_failover_enabled"{
}
variable "security_group_ids" {
  type    = list(string)
}
variable "replicas_per_node_group" {
}
variable "node_groups" {
}