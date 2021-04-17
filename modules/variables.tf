variable "name" {
  type        = string
  description = "Name of the cluster"
}
variable "replication_group_description" {
  type        = string
  description = "Describe of the cluster"
  default     = ""
}
variable "number_cache_clusters" {
  type        = number
  default     = 1
  description = "The number of cache clusters (primary and replicas) this replication group will have. If Multi-AZ is enabled, the value of this parameter must be at least 2. Updates will occur before other modifications."
}
variable "node_type" {
  type        = string
  default     = "cache.t2.micro"
  description = " The instance class to be used."
  validation {
    # regex(...) fails if it cannot find a match
    condition     = can(regex("^cache.", var.node_type))
    error_message = "The node_type value must be a valid Node Type, starting with \"cache.\"."
  }
}
variable "automatic_failover_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails. If enabled, number_cache_clusters must be greater than 1."
}
variable "multi_az_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether to enable Multi-AZ Support for the replication group."
}
variable "auto_minor_version_upgrade" {
  type        = bool
  default     = true
  description = "Specifies whether a minor engine upgrades will be applied automatically to the underlying Cache Cluster instances during the maintenance window. This parameter is currently not supported by the AWS API. Defaults to true."
}
variable "at_rest_encryption_enabled" {
  type        = bool
  default     = false
  description = "Whether to enable encryption at rest."
}
variable "transit_encryption_enabled" {
  type        = bool
  default     = false
  description = "Whether to enable encryption in transit."
}
variable "auth_token" {
  type        = string
  default     = ""
  description = "The password used to access a password protected server. Can be specified only if transit_encryption_enabled = true."
}
variable "kms_key_id" {
  type        = string
  default     = ""
  description = "The ARN of the key that you wish to use if encrypting at rest. If not supplied, uses service managed encryption. Can be specified only if at_rest_encryption_enabled = true."
}
variable "redis_engine_version" {
  type        = string
  default     = "6.x"
  description = "The version number of the cache engine to be used for the cache clusters in this replication group."
  validation {
    condition = contains(["6.x","5.0.6","4.0.10","3.2.10","3.2.6","3.2.4","2.8.24","2.8.23","2.8.22","2.8.22","2.8.19","2.8.6","2.6.13"],var.redis_engine_version)
    error_message = "Currently Redis Supported version are \"6.x\",\"5.0.6\",\"4.0.10\",\"3.2.10\",\"3.2.6\",\"3.2.4\",\"2.8.24\",\"2.8.23\",\"2.8.22\",\"2.8.22\",\"2.8.19\",\"2.8.6\",\"2.6.13\"."
  }
}

variable "redis_family" {
  type        = string
  default     = "redis6.x"
  description = "The family of the Redis cluster parameter group."
  validation {
    condition  = contains(["redis6.x","redis5.0","redis4.0","redis3.2","redis2.8","redis2.6"],var.redis_family)
    error_message = "Valid values are \"redis6.x\",\"redis5.0\",\"redis4.0\",\"redis3.2\",\"redis2.8\",\"redis2.6\"."
  }
}

variable "engine" {
  type        = string
  default     = "redis"
  description = "Specify Engine type"
  validation {
    condition     = contains(["redis", "memcached"], var.engine)
    error_message = "Aws Elasticache support 2 types of engine redis and memcached."
  }
}
variable "port" {
  type        = number
  default     = 6379
  description = "The port number on which each of the cache nodes will accept connections. For Memcache the default is 11211, and for Redis the default port is 6379."
}
variable "subnet_group_name" {
  type        = string
  default     = ""
  description = "The name of the cache subnet group to be used for the replication group."
}
variable "subnet_ids" {
  type        = list(string)
  default     = []
  description = "List of VPC Subnet IDs for the cache subnet group"
  validation {
    condition = alltrue([
      for id in var.subnet_ids : can(regex("^subnet-", id))
    ])
    error_message = "Subnet ids must start with \"subnet-\"."
  }
}
variable "security_group_ids" {
  type        = list(string)
  default     = []
  description = "One or more Amazon VPC security groups associated with this replication group. Use this parameter only when you are creating a replication group in an Amazon Virtual Private Cloud"
  validation {
    condition = alltrue([
      for id in var.security_group_ids : can(regex("^sg-", id))
    ])
    error_message = "Security group ids must start with \"sg-\"."
  }
}
variable "parameter_group_name" {
  type    = string
  default = ""
}

variable "snapshot_arns" {
  type        = list(string)
  default     = null
  description = "A list of Amazon Resource Names (ARNs) that identify Redis RDB snapshot files stored in Amazon S3. The names object names cannot contain any commas."
}
variable "snapshot_name" {
  type        = string
  default     = null
  description = "The name of a snapshot from which to restore data into the new node group. Changing the snapshot_name forces a new resource."
}
variable "maintenance_window" {
  type        = string
  default     = "sun:05:00-sun:09:00"
  description = "Specifies the weekly time range for when maintenance on the cache cluster is performed. The format is ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC). The minimum maintenance window is a 60 minute period. Example: sun:05:00-sun:09:00"
}
variable "notification_topic_arn" {
  type        = string
  default     = null
  description = "An Amazon Resource Name (ARN) of an SNS topic to send ElastiCache notifications to. Example: arn:aws:sns:us-east-1:012345678999:my_sns_topic"
}
variable "snapshot_window" {
  type        = string
  default     = "03:00-04:00"
  description = "The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. The minimum snapshot window is a 60 minute period. Example: 05:00-09:00"
}
variable "snapshot_retention_limit" {
  type        = number
  default     = 0
  description = "The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. For example, if you set SnapshotRetentionLimit to 5, then a snapshot that was taken today will be retained for 5 days before being deleted. If the value of SnapshotRetentionLimit is set to zero (0), backups are turned off. Please note that setting a snapshot_retention_limit is not supported on cache.t1.micro cache nodes"
}
variable "apply_immediately" {
  type        = bool
  default     = false
  description = "Specifies whether any modifications are applied immediately, or during the next maintenance window. Default is false."
}
variable "final_snapshot_identifier" {
  type        = string
  default     = ""
  description = "The name of your final node group (shard) snapshot. ElastiCache creates the snapshot from the primary node in the cluster. If omitted, no final snapshot will be made."
}
variable "cluster_mode_enabled" {
  type        = bool
  default     = false
  description = "Specify the mode of redis cluster means cluster mode disabled and cluster mode enabled"
}
variable "replicas_per_node_group" {
  type        = number
  default     = 0
  description = "Specify the number of replica nodes in each node group. Valid values are 0 to 5. Changing this number will trigger an online resizing operation before other settings modifications."
  validation {
    condition     = contains([0, 1, 2, 3, 4, 5], var.replicas_per_node_group)
    error_message = "Specify the number of replica nodes in each node group. Valid values are 0 to 5. Changing this number will trigger an online resizing operation before other settings modifications."
  }
}
variable "num_node_groups" {
  type        = number
  default     = 1
  description = "Specify the number of node groups (shards) for this Redis replication group. Changing this number will trigger an online resizing operation before other settings modifications."
  validation {
    condition     = contains(range(1, 91), var.num_node_groups)
    error_message = "Required when `cluster_mode_enabled` is set to true. Specify the number of node groups (shards) for this Redis replication group. Changing this number will trigger an online resizing operation before other settings modifications. Valid values are 1 to 90."
  }
}

variable "parameter" {
  type = list(object({
    name  = string
    value = string
  }))
  default     = []
  description = "A list of Redis & memcached parameters to apply depends engine type. Note that parameters may differ from one family to another"
}
variable "parameter_group_enabled" {
  type        = bool
  default     = true
  description = "If you want to create Elasticache parameter from module override this variable."
}

variable "tags" {
  type    = map(string)
  default = {}
}

#.......................memcached cluster.........................................................
variable "num_cache_nodes" {
  type    = number
  default = 1
  validation {
    condition     = contains(range(1, 21), var.num_cache_nodes)
    error_message = "For Memcached, this value must be between 1 and 20. If this number is reduced on subsequent runs, the highest numbered nodes will be removed."
  }
}
variable "az_mode" {
  type    = string
  default = "single-az"
  validation {
    condition     = contains(["single-az", "cross-az"], var.az_mode)
    error_message = "Valid values for this parameter are single-az or cross-az, default is single-az. If you want to choose cross-az, num_cache_nodes must be greater than 1."
  }
}
variable "preferred_availability_zones" {
  type    = list(string)
  default = []
}
variable "memcached_engine_version" {
  type    = string
  default = "1.6.6"
  validation {
    condition     = contains(["1.6.6", "1.5.16", "1.5.10", "1.4.34", "1.4.33", "1.4.24", "1.4.14", "1.4.5"], var.memcached_engine_version)
    error_message = "Valid values are \"1.6.6\",\"1.5.16\",\"1.5.10\",\"1.4.34\",\"1.4.33\",\"1.4.24\",\"1.4.14\",\"1.4.5\"."
  }
}
variable "memcached_family" {
  type    = string
  default = "memcached1.6"
  validation {
    condition     = contains(["memcached1.6", "memcached1.5", "memcached1.4"], var.memcached_family)
    error_message = "Supported Memcached family is \"memcached1.6\",\"memcached1.5\",\"memcached1.4\"."
  }
}
variable "replication_group_id" {
  type    = string
  default = null
}
variable "availability_zone" {
  type    = string
  default = ""
}