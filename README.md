# ElastiCache Redis cluster

[![Opstree Solutions][opstree_avatar]][opstree_homepage]<br/>[Opstree Solutions][opstree_homepage] 

  [opstree_homepage]: https://opstree.github.io/
  [opstree_avatar]: https://img.cloudposse.com/200x100/https://www.opstree.com/images/og_image8.jpg
  - This terraform module will create a complete ElastiCache cluster setup.
  - This project is a part of opstree's ot-aws initiative for terraform modules.

# What is Elasticache?
Amazon ElastiCache allows you to seamlessly set up, run, and scale popular open-source compatible in-memory data stores in the cloud. Build data-intensive apps or boost the performance of your existing databases by retrieving data from high throughput and low latency in-memory data stores. Amazon ElastiCache is a popular choice for real-time use cases like Caching, Session Stores, Gaming, Geospatial Services, Real-Time Analytics, and Queuing.

Amazon ElastiCache offers fully managed Redis, and Memcached for your most demanding applications that require sub-millisecond response times.

## Redis Architecture 
* Cluster mode disabled 
  - Redis clusters are generally placed in private subnets 
  - Cluster mode disabled – single shard 
  - A shard has a primary node and 0-5 replicas 
  - A shard with replicas is also called as a replication group 
  - Replicas can be deployed as Multi-AZ
  - Multi-AZ replicas support Auto-Failover capability
  - Single reader endpoint (auto updates replica endpoint changes)
* Cluster mode enabled
   - Cluster mode enabled – multiple shards
   - Data is distributed across the available shards
   - A shard has a primary node and 0-5 replicas
   - Multi-AZ replicas support Auto-Failover capability
   - Max 90 nodes per cluster (90 shards w/no replicas to 15 shards w/5 replicas each)
   - Minimum 3 shards recommended for HA
   - Use nitro system-based node types for higher performance (e.g. M5 / R5 etc) 

## Usage

```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.44.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

## Local tags are used to define common tags. 
locals {
  tags = { "Environment" : "test", "Client" : "DevOps", "Project" : "Demo", "Organisation" : "opstree" }
}

#Create simple Redis cluster with one node in disabled mode.
module "redis" {
  source                  = "git::https://gitlab.com/pawan-terraform/elasticache-redis.git"
  name                    = "Opstree"
  subnet_ids              = ["subnet-617asas","subnet-0avb347"]
  security_group_ids      = ["sg-0d3e8cfb1d57e11ba"]
  tags                    = local.tags
}

#Create simple Redis cluster with one node in enabled mode.
module "redis" {
  source                     = "git@gitlab.com:pawan-terraform/elasticache-redis.git"
  name                       = "Opstree"
  number_cache_clusters      = 1
  automatic_failover_enabled = true
  multi_az_enabled           = true
  cluster_mode_enabled       = true
  subnet_ids                 = ["subnet-617ae62c", "subnet-09bd3b7"]
  security_group_ids         = ["sg-0d3e8cfbd57e11ba"]
  tags                       = local.tags
}
# Example to modify parameters to tuning redis cluster.
module "redis" {
  source                = "git@gitlab.com:pawan-terraform/elasticache-redis.git"
  name                  = "Opstree"
  subnet_ids            = ["subnet-617ae62c", "subnet-09bd3b7"]
  security_group_ids    = ["sg-0d3e8cfbd57e11ba"]
  number_cache_clusters = 1 # valid only in case when cluster_mode_enabled = false
  redis_engine_version  = "5.0.6"
  redis_family          = "redis5.0"
  cluster_mode_enabled  = true
  tags                  = local.tags
  parameter = [{
    name  = "activerehashing"
    value = "no" }, {
    name  = "active-expire-effort"
    value = "2"
  }]
}
```

## Inputs

| Name | Description | Type | Default | Required | Supported |
|------|-------------|:----:|---------|:--------:|:---------:|
| name | The name of the Elasticache cluster. | `string` | | yes | |
| subnet_ids | List of VPC Subnet IDs for the cache subnet group. | `list(string)` | | yes | |
| security_group_ids | One or more Amazon VPC security groups associated with this replication group. Use this parameter only when you are creating a replication group in an Amazon Virtual Private Cloud | `list(string)` | | yes | |
| node_type | The instance class used.| `string` | `cache.t2.micro` | no | |
| maintenance_window | Specifies the weekly time range for when maintenance on the cache cluster is performed. The format is ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC).The minimum maintenance window is a 60 minute period. Example: sun:05:00-sun:09:00 | `string` | `sun:05:00-sun:09:00` | no | |
| notification_topic_arn | An Amazon Resource Name (ARN) of an SNS topic to send ElastiCache notifications to. Example: arn:aws:sns:us-east-1:012345678999:my_sns_topic |`string` | `null`| no | |
| port | The port number on which each of the cache nodes will accept connections. Redis the default port is 6379. |`string` | `6379` | no | |
| parameter_group_name | The name of the parameter group to associate with this replication group. If this argument is omitted, the default cache parameter group for the specified engine is used. To enable "cluster mode", i.e. data sharding, use a parameter group that has the parameter cluster-enabled set to true. | `string` | `null` | no | |
| apply_immediately | Specifies whether any modifications are applied immediately, or during the next maintenance window. Default is false. | `bool` | `false` | no | `true/false` |
| parameter | A list of Redis parameters to apply depends on engine type. Note that parameters may differ from one family to another. when parameter_group_enabled == true | `list(object)` | `[]` | no | |
| tags  | Specify tags values for AWS resource | `map(string)` | `{}` | no | |
| replication_group_description | A user-created description for the replication group. | `string` | `null`| no |  |
| number_cache_clusters | The number of cache clusters (primary and replicas) this replication group will have. If Multi-AZ is enabled, the value of this parameter must be at least 2. Updates will occur before other modifications. Valid this in case of Redis Cluster mode disabled | `number` | `1` | no | |
| automatic_failover_enabled | Specifies whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails. If enabled, number_cache_clusters must be greater than 1. | `bool` | `false` | no |  `true/false` |
| multi_az_enabled | Specifies whether to enable Multi-AZ Support for the replication group. | `bool` | `false` | no |  `true/false` |
| auto_minor_version_upgrade | Specifies whether a minor engine upgrades will be applied automatically to the underlying Cache Cluster instances during the maintenance window. This parameter is currently not supported by the AWS API. Defaults to true. | `bool` | `true` | no |  `true/false` |
| at_rest_encryption_enabled | Whether to enable encryption at rest. | `bool` | `false` | no |  `true/false` |
| transit_encryption_enabled | Whether to enable encryption in transit. | `bool` | `false` | no |  `true/false`|
| auth_token | The password used to access a password protected server. Can be specified only if transit_encryption_enabled = true. | `string` | `null` | no |  |
| kms_key_id | The ARN of the key that you wish to use if encrypting at rest. If not supplied, uses service managed encryption. Can be specified only if at_rest_encryption_enabled = true. | `string` | `null` | no |  |
| redis_engine_version | The version number of the cache engine to be used for the **Redis clusters** in this replication group. | `string` | `6.x` | no |  `6.x`<br>`5.0.6`<br>`4.0.10`<br>`3.2.10`<br>`3.2.6`<br>`3.2.4`<br>`2.8.24`<br>`2.8.23`<br>`2.8.22`<br>`2.8.22`<br>`2.8.19`<br>`2.8.6`<br>`2.6.13` |
| redis_family | The family of the Redis cluster parameter group. | `string` | `redis6.x` | no |  `redis6.x`<br>`redis5.0`<br>`redis4.0`<br>`redis3.2`<br>`redis2.8`<br>`redis2.6` |
| snapshot_arns | A list of Amazon Resource Names (ARNs) that identify Redis RDB snapshot files stored in Amazon S3. The names object names cannot contain any commas. | `list(string)` | `null` | no |  |
| snapshot_name | The name of a snapshot from which to restore data into the new node group. Changing the snapshot_name forces a new resource. | `string` | `null` | no |  |
| snapshot_window | The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. The minimum snapshot window is a 60 minute period. Example: 05:00-09:00 | `string` | `03:00-04:00` | no |  |
| snapshot_retention_limit | The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. For example, if you set SnapshotRetentionLimit to 5, then a snapshot that was taken today will be retained for 5 days before being deleted. If the value of SnapshotRetentionLimit is set to zero (0), backups are turned off. Please note that setting a snapshot_retention_limit is not supported on cache.t1.micro cache nodes | `number` | `0` | no | |
| final_snapshot_identifier | The name of your final node group (shard) snapshot. ElastiCache creates the snapshot from the primary node in the cluster. If omitted, no final snapshot will be made. | `string` | `null` | no |  |
| cluster_mode_enabled | Specify the mode of redis cluster means cluster mode disabled and cluster mode enabled | `bool` | `false` | no |  |
| replicas_per_node_group | Specify the number of replica nodes in each node group. Valid values are 0 to 5. Changing this number will trigger an online resizing operation before other settings modifications. valid only when cluster_mode_enabled = true | `number` | `0` | no |  `0 to 5` |
| num_node_groups | Specify the number of node groups (shards) for this Redis replication group. Changing this number will trigger an online resizing operation before other settings modifications. | `number` | `1` | no |  `1 to 90` | |
#

## Outputs

| Name | Description |  
|------|-------------| 
| arn | The Amazon Resource Name (ARN) of the created Redis ElastiCache Cluster. | 
| id | The ID of the ElastiCache Replication Group. | 
| cluster_enabled | Indicates if cluster mode is enabled. | 
| configuration_endpoint_address | The address of the replication group configuration endpoint when cluster mode is enabled. | 
| primary_endpoint_address | The address of the endpoint for the primary node in the replication group, if the cluster mode is disabled. | 
| reader_endpoint_address | The address of the endpoint for the reader node in the replication group, if the cluster mode is disabled. | 
| auth_token | For auto generated password | 

#
## Contributors

[![Pawan Chandna][pawan_avatar]][pawan_homepage]<br/>[Pawan Chandna][pawan_homepage]

  [pawan_homepage]: https://gitlab.com/pawan.chandna
  [pawan_avatar]: https://img.cloudposse.com/75x75/https://gitlab.com/uploads/-/system/user/avatar/7777967/avatar.png?width=400
