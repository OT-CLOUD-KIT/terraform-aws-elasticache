locals {
  tags = { "ENVIRONMENT" : "test", "CLIENT" : "DEVOPS", "PROJECT" : "Demo", "ORGANISATION" : "opstree" }
}

module "redis" {
  source                  = "./modules"
  name                    = "Opstree"
  redis_engine_version    = "5.0.6"
  number_cache_clusters   = 2
  replicas_per_node_group = 1
  num_node_groups         = 1
}
module "memcached" {
  source                   = "./modules"
  name                     = "Opstree"
  engine                   = "memcached"
  memcached_engine_version = "1.6.6"
  memcached_family         = "memcached1.6"
  num_cache_nodes          = 1
  port                     = 11211
  tags                     = merge({ PROVISIONER = "Terraform" }, local.tags)
}
