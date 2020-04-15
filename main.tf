/*-------------------------------------------------------*/
resource "aws_elasticache_subnet_group" "elasticache" {
  name       = "${var.env}-${var.namespace}-cache-subnet"
  subnet_ids = var.subnet_ids
}
/*-------------------------------------------------------*/
resource "aws_elasticache_replication_group" "redis" {
  replication_group_id          = "${var.env}-${var.replication_group_id}"
  replication_group_description = "Redis cluster for ElastiCache"
  node_type                     = var.redis_node_type
  port                          = var.redis_port
  parameter_group_name          = var.redis_parameter_group_name
  engine_version                = var.redis_version
  snapshot_retention_limit      = var.redis_snapshot_retention_limit
  maintenance_window            = var.redis_maintenance_window
  snapshot_window               = var.redis_snapshot_window
  auth_token                    = random_string.auth_token.result
  transit_encryption_enabled    = var.transit_encryption_enabled
  at_rest_encryption_enabled    = var.at_rest_encryption_enabled
  subnet_group_name             = aws_elasticache_subnet_group.elasticache.name
  automatic_failover_enabled    = var.automatic_failover_enabled
  security_group_ids            = var.security_group_ids
  cluster_mode {
    replicas_per_node_group     = var.replicas_per_node_group
    num_node_groups             = var.node_groups
  }
}
/*-------------------------------------------------------*/
resource "random_string" "auth_token" {
  length                        = 64
  special                       = false
}
