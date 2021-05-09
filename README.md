# ElastiCache_cluster

[![Opstree Solutions][opstree_avatar]][opstree_homepage]<br/>[Opstree Solutions][opstree_homepage] 

  [opstree_homepage]: https://opstree.github.io/
  [opstree_avatar]: https://img.cloudposse.com/200x100/https://www.opstree.com/images/og_image8.jpg
  - This terraform module will create a complete ElastiCache cluster setup.
  - This project is a part of opstree's ot-aws initiative for terraform modules.

## Usage

```
module "redis" {
  source                  = "./modules"
  name                    = "Opstree"
}
module "memcached" {
  source                   = "./modules"
  name                     = "Opstree"
}
```


## Inputs

| Name | Description | Type | Default | Required | Redis/Memcached | Supported |
|------|-------------|:----:|---------|:--------:|:------:|:---------:|
| name | The name of the Elasticache cluster. | `string` |`null`| yes | Common for both | |
| node_type | The instance class used.| `string` | `cache.t2.micro` | no | Common for both | |
| maintenance_window | Specifies the weekly time range for when maintenance on the cache cluster is performed. The format is ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC).The minimum maintenance window is a 60 minute period. Example: sun:05:00-sun:09:00 | `string` | `sun:05:00-sun:09:00` | no | Common for both | |
| notification_topic_arn | An Amazon Resource Name (ARN) of an SNS topic to send ElastiCache notifications to. Example: arn:aws:sns:us-east-1:012345678999:my_sns_topic |`string` | `null`| no | Common for both | |
| engine | Specify Elasticache Engine type | `number` | `redis` | no | common for both | `redis`<br>`memcached` |
| port | The port number on which each of the cache nodes will accept connections. For Memcache the default is 11211, and for Redis the default port is 6379. |`string` | `6379` | no | common for both | |
| subnet_group_name | The name of the cache subnet group to be used for the replication group. | `string` | `null` | no | common for both | |
| subnet_ids | List of VPC Subnet IDs for the cache subnet group. | `list(string)` | `[]` | no | common for both | |
| security_group_ids | One or more Amazon VPC security groups associated with this replication group. Use this parameter only when you are creating a replication group in an Amazon Virtual Private Cloud | `list(string)` | `[]` | no | common for both | |
| parameter_group_name | The name of the parameter group to associate with this replication group. If this argument is omitted, the default cache parameter group for the specified engine is used. To enable "cluster mode", i.e. data sharding, use a parameter group that has the parameter cluster-enabled set to true. | `string` | `null` | no | common for both | |
| apply_immediately | Specifies whether any modifications are applied immediately, or during the next maintenance window. Default is false. | `bool` | `false` | no | common for both | |
| parameter_group_enabled | If you want to create Elasticache parameter from module override this variable. | `bool` | `true` | no | common for both | `true/false` |
| parameter | A list of Redis & memcached parameters to apply depends engine type. Note that parameters may differ from one family to another. when parameter_group_enabled == true | `list(object)` | `[]` | no | common for both | |
| tags  | Specify tags values for AWS resource | `map(string)` | `{}` | no | common for both | |
| replication_group_description | A user-created description for the replication group. | `string` | `null`| no | Redis | |
| number_cache_clusters | The number of cache clusters (primary and replicas) this replication group will have. If Multi-AZ is enabled, the value of this parameter must be at least 2. Updates will occur before other modifications. Valid this in case of Redis Cluster mode disabled | `number` | `1` | no | Redis ||
| automatic_failover_enabled | Specifies whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails. If enabled, number_cache_clusters must be greater than 1. | `bool` | `false` | no | Redis ||
| multi_az_enabled | Specifies whether to enable Multi-AZ Support for the replication group. | `bool` | `false` | no | Redis | `true/false` |
| auto_minor_version_upgrade | Specifies whether a minor engine upgrades will be applied automatically to the underlying Cache Cluster instances during the maintenance window. This parameter is currently not supported by the AWS API. Defaults to true. | `bool` | `true` | no | Redis | `true/false` |
| at_rest_encryption_enabled | Whether to enable encryption at rest. | `bool` | `false` | no | Redis ||
| transit_encryption_enabled | Whether to enable encryption in transit. | `bool` | `false` | no | Redis | `true/false`|
| auth_token | The password used to access a password protected server. Can be specified only if transit_encryption_enabled = true. | `string` | `null` | no | Redis | `true/false` |
| kms_key_id | The ARN of the key that you wish to use if encrypting at rest. If not supplied, uses service managed encryption. Can be specified only if at_rest_encryption_enabled = true. | `string` | `null` | no | Redis | `true/false` |
| redis_engine_version | The version number of the cache engine to be used for the **Redis clusters** in this replication group. | `string` | `6.x` | no | Redis | `6.x`<br>`5.0.6`<br>`4.0.10`<br>`3.2.10`<br>`3.2.6`<br>`3.2.4`<br>`2.8.24`<br>`2.8.23`<br>`2.8.22`<br>`2.8.22`<br>`2.8.19`<br>`2.8.6`<br>`2.6.13` |
| redis_family | The family of the Redis cluster parameter group. | `string` | `redis6.x` | no | Redis | `redis6.x`<br>`redis5.0`<br>`redis4.0`<br>`redis3.2`<br>`redis2.8`<br>`redis2.6` |
| snapshot_arns | A list of Amazon Resource Names (ARNs) that identify Redis RDB snapshot files stored in Amazon S3. The names object names cannot contain any commas. | `list(string)` | `null` | no | redis | |
| snapshot_name | The name of a snapshot from which to restore data into the new node group. Changing the snapshot_name forces a new resource. | `string` | `null` | no | Redis | |
| snapshot_window | The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. The minimum snapshot window is a 60 minute period. Example: 05:00-09:00 | `string` | `03:00-04:00` | no | Redis | |
| snapshot_retention_limit | The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. For example, if you set SnapshotRetentionLimit to 5, then a snapshot that was taken today will be retained for 5 days before being deleted. If the value of SnapshotRetentionLimit is set to zero (0), backups are turned off. Please note that setting a snapshot_retention_limit is not supported on cache.t1.micro cache nodes | `number` | `0` | no | Redis ||
| final_snapshot_identifier | The name of your final node group (shard) snapshot. ElastiCache creates the snapshot from the primary node in the cluster. If omitted, no final snapshot will be made. | `string` | `null` | no | Redis | |
| cluster_mode_enabled | Specify the mode of redis cluster means cluster mode disabled and cluster mode enabled | `bool` | `false` | no | Redis | |
| replicas_per_node_group | Specify the number of replica nodes in each node group. Valid values are 0 to 5. Changing this number will trigger an online resizing operation before other settings modifications. valid only when cluster_mode_enabled = true | `number` | `0` | no | Redis | `0,1,2,3,4,5` |
| num_node_groups | Specify the number of node groups (shards) for this Redis replication group. Changing this number will trigger an online resizing operation before other settings modifications. | `number` | `1` | no | Redis | `1 to 90` | |
| num_cache_nodes | For Memcached, this value must be between 1 and 20. If this number is reduced on subsequent runs, the highest numbered nodes will be removed. | `number` | `1` | no | Memcached | `1 to 20` |
| az_mode | Valid values for this parameter are single-az or cross-az, default is single-az. If you want to choose cross-az, num_cache_nodes must be greater than 1. | `string` | `single-az` | no |  memcached | `single-az`<br>`cross-az` |
| memcached_engine_version | Version number of the memcached engine to be used. | `string` | `1.6.6` | no | memcached | `1.6.6`<br>`1.5.16`<br>`1.5.10`<br>`1.4.34`<br>`1.4.33`<br>`1.4.24`<br>`1.4.14`<br>`1.4.5` | 
| memcached_family | The family of the Memcached cluster parameter group. | `string` | `memcached1.6` | no | memcached | `memcached1.6`<br>`memcached1.5`<br>`memcached1.4` |
| availability_zone | Availability Zone for the cache cluster. If you want to create cache nodes in multi-az, use preferred_availability_zones instead. Default: System chosen Availability Zone. Changing this value will re-create the resource. | `string` | `null` | no | memcached | |
| preferred_availability_zones | List of the Availability Zones in which cache nodes are created. If you are creating your cluster in an Amazon VPC you can only locate nodes in Availability Zones that are associated with the subnets in the selected subnet group. | `list(string)` | `[]` | no | memcached | |
#

## Outputs

| Name | Description | Redis/Memcached | 
|------|-------------| :---------------: |
| arn | The Amazon Resource Name (ARN) of the created Redis ElastiCache Cluster. | Redis |
| id | The ID of the ElastiCache Replication Group. | Redis |
| cluster_enabled | Indicates if cluster mode is enabled. | Redis |
| configuration_endpoint_address | The address of the replication group configuration endpoint when cluster mode is enabled. | Redis |
| primary_endpoint_address | The address of the endpoint for the primary node in the replication group, if the cluster mode is disabled. | Redis |
| reader_endpoint_address | The address of the endpoint for the reader node in the replication group, if the cluster mode is disabled. | Redis |
| auth_token | For auto generated password | Redis |
||||
| mem_arn | The ARN of the created Memcached ElastiCache Cluster. | Memcached | 
|configuration_endpoint | The configuration endpoint to allow host discovery. | Memcahed |
| cluster_address | The DNS name of the cache cluster without the port appended. | Memcached |
| cache_nodes | List of node objects including id, address, port and availability_zone. | Memcached |

#
## Contributors

[![Shweta Tyagi][shweta_avatar]][shweta_homepage]&nbsp;&nbsp;[![Pawan Chandna][pawan_avatar]][pawan_homepage]<br/>[Shweta Tyagi][shweta_homepage]&nbsp;&nbsp;[Pawan Chandna][pawan_homepage]

  [shweta_homepage]: https://github.com/shwetatyagi-ot
  [shweta_avatar]: https://img.cloudposse.com/75x75/https://github.com/shwetatyagi-ot.png
  [pawan_homepage]: https://gitlab.com/pawan.chandna
  [pawan_avatar]: https://img.cloudposse.com/75x75/https://gitlab.com/uploads/-/system/user/avatar/7777967/avatar.png?width=400
