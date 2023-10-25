/*-------------------------------------------------------*/
resource "aws_elasticache_subnet_group" "elasticache" {
  name       = "${var.env}-${var.name}-redis-cache-subnet"
  subnet_ids = var.subnet_ids
  tags       = merge({ "Provisioned" = "Terraform" }, var.tags)
}

/*-------------------------------------------------------*/
resource "random_string" "auth_token" {
  count   = var.transit_encryption_enabled ? 1 : 0
  length  = 64
  special = false
}
/*-------------------------------------------------------*/
resource "aws_elasticache_parameter_group" "default" {
  count  = length(var.parameter_group_name) == 0 && var.parameter_group_enabled ? 1 : 0
  name   = "${var.env}-parameter-group-redis-${var.name}${var.cluster_mode_enabled ? "-cluster-on" : ""}"
  family = var.redis_family

  dynamic "parameter" {
    for_each = var.cluster_mode_enabled ? concat([{ name = "cluster-enabled", value = "yes" }], var.parameter) : var.parameter
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }
}

/*-------------------------------------------------------*/
resource "aws_elasticache_replication_group" "redis" {
  replication_group_id          = "${var.env}-${lower(var.name)}-redis-cluster"
  replication_group_description = var.replication_group_description != "" ? var.replication_group_description : "${var.name} Redis Cluster"
  number_cache_clusters         = var.cluster_mode_enabled ? null : ((var.automatic_failover_enabled || var.multi_az_enabled) && var.number_cache_clusters == 1 ? var.number_cache_clusters + 1 : var.number_cache_clusters)
  node_type                     = var.node_type
  automatic_failover_enabled    = (var.multi_az_enabled || var.cluster_mode_enabled) ? true : var.automatic_failover_enabled
  multi_az_enabled              = var.multi_az_enabled
  auto_minor_version_upgrade    = var.auto_minor_version_upgrade
  engine                        = "redis"
  at_rest_encryption_enabled    = var.at_rest_encryption_enabled
  transit_encryption_enabled    = var.transit_encryption_enabled
  auth_token                    = var.transit_encryption_enabled == true ? coalesce(var.auth_token, random_string.auth_token[0].result) : null
  kms_key_id                    = var.at_rest_encryption_enabled == true ? coalesce(var.kms_key_id, null) : null
  engine_version                = var.redis_engine_version
  parameter_group_name          = coalesce(var.parameter_group_name, join("", aws_elasticache_parameter_group.default.*.name))
  port                          = var.port
  subnet_group_name             = aws_elasticache_subnet_group.elasticache.name
  security_group_ids            = var.security_group_ids
  snapshot_arns                 = var.snapshot_arns
  snapshot_name                 = var.snapshot_name
  maintenance_window            = var.maintenance_window
  notification_topic_arn        = var.notification_topic_arn
  snapshot_window               = var.snapshot_window
  snapshot_retention_limit      = var.snapshot_retention_limit
  apply_immediately             = var.apply_immediately
  final_snapshot_identifier     = var.final_snapshot_identifier
  tags                          = merge({ "Provisioned" = "Terraform" }, var.tags)
  dynamic "cluster_mode" {
    for_each = var.cluster_mode_enabled ? ["true"] : []
    content {
      replicas_per_node_group = var.replicas_per_node_group
      num_node_groups         = var.num_node_groups
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "cache_cpu" {
  count = var.alarm_enabled ? var.number_cache_clusters : 0

  alarm_name          = "${aws_elasticache_replication_group.redis.id}-CacheCluster00${count.index + 1}-CPUUtilization"
  alarm_description   = "Redis cluster CPU utilization for ${aws_elasticache_replication_group.redis.id} is high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_period
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = var.statistic_period
  statistic           = "Average"
  alarm_actions       = var.actions_alarm
  ok_actions = var.actions_ok

  threshold = "${var.alarm_cpu_threshold}"

  dimensions = {
    CacheClusterId = "${aws_elasticache_replication_group.redis.id}-00${count.index + 1}"
  }
}

resource "aws_cloudwatch_metric_alarm" "cache_memory" {
  count = var.alarm_enabled ? var.number_cache_clusters : 0

  alarm_name          = "${aws_elasticache_replication_group.redis.id}-CacheCluster00${count.index + 1}-FreeableMemory"
  alarm_description   = "Redis cluster freeable memory for ${aws_elasticache_replication_group.redis.id} is low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_period
  metric_name         = "FreeableMemory"
  namespace           = "AWS/ElastiCache"
  period              = var.statistic_period
  statistic           = "Average"
  alarm_actions = var.actions_alarm
  ok_actions = var.actions_ok

  threshold = "${var.alarm_memory_threshold}"

  dimensions = {
    CacheClusterId = "${aws_elasticache_replication_group.redis.id}-00${count.index + 1}"
  }

}


resource "aws_cloudwatch_metric_alarm" "elasticache_cloudwatch_alarm_currconnections" {
  count = var.alarm_enabled ? var.number_cache_clusters : 0
  alarm_name          = "${aws_elasticache_replication_group.redis.id}-CacheCluster00${count.index + 1}-Currconnections"
  alarm_description   = "CurrConnections for ${aws_elasticache_replication_group.redis.id} have been greater pretty high. Something unusual is happening."
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_period
  metric_name         = "CurrConnections"
  namespace           = "AWS/ElastiCache"
  period              = var.statistic_period
  threshold           = var.alarm_Curuuconnections_threshold
  statistic           = "Average"
  alarm_actions = var.actions_alarm
  ok_actions = var.actions_ok
  
  dimensions = {
    CacheClusterId = "${aws_elasticache_replication_group.redis.id}-00${count.index + 1}"
  }

}
