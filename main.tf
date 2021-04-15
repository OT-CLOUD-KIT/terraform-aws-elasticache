module "redis" {
  source                     = "./modules"
  name                       = "Opstree"
  engine_version             = "5.0.6"
  multi_az_enabled           = true
  automatic_failover_enabled = true
  number_cache_clusters      = 2
# at_rest_encryption_enabled = true
# kms_key_id                 = "arn:aws:kms:us-east-1:248435113315:key/d9055558-66ef-4464-b12d-407640a25a1d"
# transit_encryption_enabled = true
# cluster_mode_enabled       = true
  replicas_per_node_group    = 1
  num_node_groups            = 1
# final_snapshot_identifier  = "backupredis"
}
