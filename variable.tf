variable "namespace" {
  description = "Default namespace"
}
variable "replication_group_id" {
  description = "Id to assign the new cluster"
}

variable "node_groups" {
  description = "Number of nodes groups to create in the cluster"
  default     = 1
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type    = list(string)
  default = []
}

variable "env" {
  description = "env to deploy into, should typically ab_dev/ab_qa/ab_prod"
}
variable "redis_port" {
  default = 6379
}

variable "redis_node_type" {
  description = "Instance type to use for creating the Redis cache clusters"
  default     = ""
}

variable "redis_parameter_group_name" {
  description = "redis parameter group name"
  default     = "default.redis5.0.cluster.on"
}

variable "redis_version" {
  description = "Redis version to use, defaults to 3.2.10"
  default     = "5.0.5"
}

variable "redis_maintenance_window" {
  description = "Specifies the weekly time range for when maintenance on the cache cluster is performed. The format is ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC). The minimum maintenance window is a 60 minute period"
  default     = "fri:08:00-fri:09:00"
}

variable "redis_snapshot_window" {
  description = "The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. The minimum snapshot window is a 60 minute period"
  default     = "06:30-07:30"
}

variable "redis_snapshot_retention_limit" {
  description = "The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. For example, if you set SnapshotRetentionLimit to 5, then a snapshot that was taken today will be retained for 5 days before being deleted. If the value of SnapshotRetentionLimit is set to zero (0), backups are turned off. Please note that setting a snapshot_retention_limit is not supported on cache.t1.micro or cache.t2.* cache nodes"
  default     = 0
}

variable "replicas_per_node_group" {
  default     = ""
}
