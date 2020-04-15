# ElastiCache_cluster

[![Opstree Solutions][opstree_avatar]][opstree_homepage]<br/>[Opstree Solutions][opstree_homepage] 

  [opstree_homepage]: https://opstree.github.io/
  [opstree_avatar]: https://img.cloudposse.com/150x150/https://github.com/opstree.png

- This terraform module will create a complete ElastiCache cluster setup.
- This project is a part of opstree's ot-aws initiative for terraform modules.

## Usage

```sh
$   cat main.tf
/*-------------------------------------------------------*/
module "redis_cluster" {
  source                         = "../redis"
  node_groups                    = 1
  replicas_per_node_group        = 1
  redis_node_type                = "cache.t2.micro"
  redis_version                  = "5.0.5"
  redis_port                     = 6379
  redis_parameter_group_name     = "default.redis5.0.cluster.on"
  redis_maintenance_window       = "fri:08:00-fri:09:00"
  redis_snapshot_window          = "06:30-07:30"
  redis_snapshot_retention_limit = 0
  transit_encryption_enabled     = true
  at_rest_encryption_enabled     = true
  automatic_failover_enabled     = true
  subnet_ids                     = ["subnet-eba21aa6", "subnet-83e712dc"]
  namespace                      = "elastiCache"
  replication_group_id           = "elastiCache"
  env                            = "opstree-dev"
  security_group_ids             = [aws_security_group.frontend_sg.id]
}
/*-------------------------------------------------------*/
resource "aws_security_group" "frontend_sg" {
  name = "Frontend Security Group"
  vpc_id      = "vpc-fc5cc595"

  ingress {
      from_port = 6379
      to_port = 6379
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Terraform = "true"
  }
}
/*-------------------------------------------------------*/
/*-------------------------------------------------------*/
```

```sh
$   cat output.tf
/*-------------------------------------------------------*/
output "auth_token" {
  value = module.redis_cluster.auth_token
}
/*-------------------------------------------------------*/
```
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| namespace | The name of the redis cluster. | `string` | `null` | yes |
| env | The name of environment, this is helpful if you have more than 1 cluster. | `string` | `null` | yes |
| subnet_ids | The subnets where the redis cluster is deployed. | `string` | `null` | yes |
| replication_group_id | The ID of the replication group to which this cluster should belong. | `string` | `null` | yes |
| redis_node_type | The instance size of the redis cluster. | `string` | `null` | yes |
| redis_port | The redis port. | `string` | `6379` | no |
| redis_parameter_group_name | The Name of the parameter group to associate with this cache cluster. | `string` | `null` | yes |
| redis_version | The Version number of the cache engine to be used. | `string` | `3.2.10` | no |
| redis_snapshot_retention_limit | The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. | `string` | `0` | no |
| redis_maintenance_window | Specifies the weekly time range for when maintenance on the cache cluster is performed. | `string` | `null` | no |
| redis_snapshot_window | The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. | `string` | `null` | no |
| transit_encryption_enabled | Whether to enable encryption in transit. | `bool` | `false` | no |
| at_rest_encryption_enabled | Whether to enable encryption in rest. | `bool` | `false` | no |
| automatic_failover_enabled |Specifies whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails. | `bool` | `false` | no |
| security_group_ids | Security groups associated with the cache cluster. | `list` | `null` | no |
| replicas_per_node_group | Number of nodes replicas to create in the cluster. | `string` | `null` | yes |
| node_groups | Number of nodes groups to create in the cluster. | `string` | `null` | yes |

## Outputs

| Name | Description |
|------|-------------|
| primary_endpoint_address | The address of the replication group configuration endpoint when cluster mode is enabled |
| db_instance_port | Port of the DB instance |


## Related Projects

Check out these related projects.

- [network_skeleton](https://gitlab.com/ot-aws/terrafrom_v0.12.21/network_skeleton) - Terraform module for providing a general purpose Networking solution
- [security_group](https://gitlab.com/ot-aws/terrafrom_v0.12.21/security_group) - Terraform module for creating dynamic Security groups
- [eks](https://gitlab.com/ot-aws/terrafrom_v0.12.21/eks) - Terraform module for creating elastic kubernetes cluster.
- [HA_ec2_alb](https://gitlab.com/ot-aws/terrafrom_v0.12.21/ha_ec2_alb.git) - Terraform module for creating a Highly available setup of an EC2 instance with quick disater recovery.
- [HA_ec2](https://gitlab.com/ot-aws/terrafrom_v0.12.21/ha_ec2.git) - Terraform module for creating a Highly available setup of an EC2 instance with quick disater recovery.
- [rolling_deployment](https://gitlab.com/ot-aws/terrafrom_v0.12.21/rolling_deployment.git) - This terraform module will orchestrate rolling deployment.

### Contributors

[![Shweta Tyagi][shweta_avatar]][shweta_homepage]<br/>[Shweta Tyagi][shweta_homepage] 

  [shweta_homepage]: https://github.com/shwetatyagi-ot
  [shweta_avatar]: https://img.cloudposse.com/75x75/https://github.com/shwetatyagi-ot.png
