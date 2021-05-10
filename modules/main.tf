/*-------------------------------------------------------*/
resource "aws_elasticache_subnet_group" "elasticache" {
  name       = "${var.name}-${var.engine}-cache-subnet"
  subnet_ids = coalescelist(var.subnet_ids, [for s in data.aws_subnet.subnet : s.id])
}

/*-------------------------------------------------------*/
resource "random_string" "auth_token" {
  count   = var.engine == "redis" && var.transit_encryption_enabled ? 1 : 0
  length  = 64
  special = false
}
/*-------------------------------------------------------*/
resource "aws_security_group" "redis_sg" {
  count  =  length(var.security_group_ids) ==0 && var.engine == "redis" ? 1 : 0
  name   = "${var.name}-${var.engine}-cluster-sg"
  vpc_id = data.aws_vpc.vpc.id
  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.vpc.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.tags
}
resource "aws_security_group" "memcached_sg" {
  count  =  length(var.security_group_ids) ==0 && var.engine == "memcached" ? 1 : 0
  name   = "${var.name}-${var.engine}-cluster-sg"
  vpc_id = data.aws_vpc.vpc.id
  ingress {
    from_port   = 11211
    to_port     = 11211
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.vpc.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.tags
}
/*-------------------------------------------------------*/
resource "aws_elasticache_parameter_group" "default" {
  count  = length(var.parameter_group_name) == 0 && var.parameter_group_enabled ? 1 : 0
  name   = "parameter-group-${var.engine}-${var.name}${var.engine == "redis" && var.cluster_mode_enabled ? "-cluster-on" : ""}"
  family = var.engine == "redis" ? var.redis_family : var.memcached_family

  dynamic "parameter" {
    for_each = var.engine == "redis" && var.cluster_mode_enabled ? concat([{ name = "cluster-enabled", value = "yes" }], var.parameter) : var.parameter
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }
}
/*-------------------------------------------------------*/
resource "aws_elasticache_replication_group" "redis" {
  count                         = var.engine == "redis" ? 1 : 0
  replication_group_id          = "${lower(var.name)}-redis-cluster"
  replication_group_description = var.replication_group_description != "" ? var.replication_group_description : "${var.name} Redis Cluster"
  number_cache_clusters         = var.cluster_mode_enabled ? null : ( var.automatic_failover_enabled && var.number_cache_clusters == 1 ? var.number_cache_clusters+1 : var.number_cache_clusters)
  node_type                     = var.node_type
  automatic_failover_enabled    = var.multi_az_enabled ? true : var.automatic_failover_enabled
  multi_az_enabled              = var.multi_az_enabled
  auto_minor_version_upgrade    = var.auto_minor_version_upgrade
  engine                        = var.engine
  at_rest_encryption_enabled    = var.at_rest_encryption_enabled
  transit_encryption_enabled    = var.transit_encryption_enabled
  auth_token                    = var.transit_encryption_enabled == true ? coalesce(var.auth_token, random_string.auth_token[count.index].result) : null
  kms_key_id                    = var.at_rest_encryption_enabled == true ? coalesce(var.kms_key_id, null) : null
  engine_version                = var.redis_engine_version
  parameter_group_name          = coalesce(var.parameter_group_name, join("", aws_elasticache_parameter_group.default.*.name))
  port                          = var.port
  subnet_group_name             = coalesce(var.subnet_group_name, aws_elasticache_subnet_group.elasticache.name)
  security_group_ids            = coalescelist(var.security_group_ids, aws_security_group.redis_sg.*.id)
  snapshot_arns                 = var.snapshot_arns
  snapshot_name                 = var.snapshot_name
  maintenance_window            = var.maintenance_window
  notification_topic_arn        = var.notification_topic_arn
  snapshot_window               = var.snapshot_window
  snapshot_retention_limit      = var.snapshot_retention_limit
  apply_immediately             = var.apply_immediately
  final_snapshot_identifier     = var.final_snapshot_identifier
  tags                          = var.tags
  dynamic "cluster_mode" {
    for_each = var.cluster_mode_enabled ? ["true"] : []
    content {
      replicas_per_node_group = var.replicas_per_node_group
      num_node_groups         = var.num_node_groups
    }
  }
}

resource "aws_elasticache_cluster" "memcached" {
  count                        = var.engine == "memcached" ? 1 : 0
  cluster_id                   = "${lower(var.name)}-memcached-cluster"
  replication_group_id         = var.replication_group_id
  engine                       = var.engine
  engine_version               = var.memcached_engine_version
  maintenance_window           = var.maintenance_window
  node_type                    = var.node_type
  num_cache_nodes              = var.num_cache_nodes
  parameter_group_name         = coalesce(var.parameter_group_name, join("", aws_elasticache_parameter_group.default.*.name))
  port                         = var.port
  subnet_group_name            = coalesce(var.subnet_group_name, aws_elasticache_subnet_group.elasticache.name)
  security_group_ids           = coalescelist(var.security_group_ids, aws_security_group.memcached_sg.*.id)
  apply_immediately            = var.apply_immediately
  notification_topic_arn       = var.notification_topic_arn
  az_mode                      = var.az_mode
  availability_zone            = var.availability_zone
  preferred_availability_zones = var.preferred_availability_zones
  final_snapshot_identifier    = var.final_snapshot_identifier
  tags                         = var.tags
}

