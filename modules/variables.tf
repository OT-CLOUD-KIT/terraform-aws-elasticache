variable "name" {
  type        = string
  description = "(optional) describe your variable"
}
variable "replication_group_description" {
  type        = string
  description = "(optional) describe your variable"
  default     = ""
}
variable "global_replication_group_id" {
  default = ""
}
variable "number_cache_clusters" {
  default = 1
}
variable "node_type" {
  type    = string
  default = "cache.t2.micro"
  validation {
    # regex(...) fails if it cannot find a match
    condition     = can(regex("^cache.", var.node_type))
    error_message = "The node_type value must be a valid Node Type, starting with \"cache.\"."
  }
}
variable "automatic_failover_enabled" {
  type    = bool
  default = false
}
variable "multi_az_enabled" {
  type    = bool
  default = false
}
variable "auto_minor_version_upgrade" {
  type    = bool
  default = true
}
variable "availability_zones" {
  type    = list(string)
  default = [""]
}
variable "at_rest_encryption_enabled" {
  type    = bool
  default = false
}
variable "transit_encryption_enabled" {
  type    = bool
  default = false
}
variable "auth_token" {
  type    = string
  default = ""

}
variable "kms_key_id" {
  type    = string
  default = ""
}
variable "engine_version" {
  type    = string
  default = "5.0.6"
}
# variable "parameter_group_name" {

# }
variable "port" {
  type    = number
  default = 6379
}
variable "subnet_group_name" {
  type    = string
  default = ""
}
variable "subnet_ids" {
  type    = list(string)
  default = []
    validation {
    condition = alltrue([
      for id in var.subnet_ids : can(regex("^subnet-", id))
    ])
    error_message = "Subnet ids must start with \"subnet-\"."
  }
}
variable "security_group_ids" {
  type    = list(string)
  default = []
  validation {
    condition = alltrue([
      for id in var.security_group_ids : can(regex("^sg-", id))
    ])
    error_message = "All security group ids must start with \"sg-\"."
  }
}
variable "security_group_names" {
  type    = string
  default = ""
}
variable "snapshot_arns" {
  type    = list(string)
  default = null
}
variable "snapshot_name" {
  type    = string
  default = null
}
variable "maintenance_window" {
  type    = string
  default = "sun:05:00-sun:09:00"
}
variable "notification_topic_arn" {
  type    = string
  default = null
  # validation {
  #   # regex(...) fails if it cannot find a match
  #   condition     = can(regexall("null || (^arn:aws:sns:(us(-gov)?|ap|ca|cn|eu|sa)-(central|(north|south)?(east|west)?)-\\d\\:\\d{12}\\:)", var.notification_topic_arn))
  #   error_message = "The notification_topic_arn value must be a valid SNS ARN, starting with \"arn:aws:sns:<region name>:<accountid>:<topic_name>\"."
  # }
  # validation {
  #   condition = alltrue([ for id in var.notification_topic_arn : can(regex("^arn:aws:sns:", id))])
  #   error_message = "SNS Notification topic ARN must start with \"arn:aws:sns:\"."
  # }
}
variable "snapshot_window" {
  type    = string
  default = "03:00-04:00"
}
variable "snapshot_retention_limit" {
  type    = number
  default = 1
}
variable "apply_immediately" {
  type    = bool
  default = false
}
variable "final_snapshot_identifier" {
  type    = string
  default = ""
}
variable "cluster_mode_enabled" {
  type    = bool
  default = true
}
variable "replicas_per_node_group" {
  type    = number
  default = 0
  validation {
    condition     = contains([0, 1, 2, 3, 4, 5], var.replicas_per_node_group)
    error_message = "Specify the number of replica nodes in each node group. Valid values are 0 to 5. Changing this number will trigger an online resizing operation before other settings modifications."
  }
}
variable "num_node_groups" {
  type    = number
  default = 1
  validation {
    condition     = contains(range(1,91),var.num_node_groups)
    error_message = "Required when `cluster_mode_enabled` is set to true. Specify the number of node groups (shards) for this Redis replication group. Changing this number will trigger an online resizing operation before other settings modifications. Valid values are 1 to 90."
  }
}
variable "family" {
  type        = string
  default     = "redis5.0"
  description = "Redis family"
}

variable "parameter" {
  type = list(object({
    name  = string
    value = string
  }))
  default     = []
  description = "A list of Redis parameters to apply. Note that parameters may differ from one Redis family to another"
}
variable "enabled" {
  type    = bool
  default = true
}
variable "engine" {
  type = string
  default = "redis"
    validation {
    condition     = contains(["redis","memcached"],var.engine)
    error_message = "AWS support 2 types of elasticache cluster one is redis and 2nd is memcached."
  }
}