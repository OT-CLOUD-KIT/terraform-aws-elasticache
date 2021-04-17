output "redis_cluster_arn" {
  value = module.redis.arn
}
output "redis_cluster_id" {
  value = module.redis.id
}
output "redis_cluster_configuration_endpoint_address" {
  value = module.redis.configuration_endpoint_address
}
output "redis_cluster_primary_endpoint_address" {
  value = module.redis.primary_endpoint_address
}
output "redis_cluster_reader_endpoint_address" {
  value = module.redis.reader_endpoint_address
}
output "redis_cluster_auth_token" {
  value = module.redis.auth_token
}
output "redis_cluster_enabled" {
  value = module.redis.cluster_enabled
}
output "memcached_cluster_arn" {
  value = module.memcached.mem_arn
}
output "memcached_cluster_configuration_endpoint" {
  value = module.memcached.configuration_endpoint
}
output "memcached_cluster_cluster_address" {
  value = module.memcached.cluster_address
}
output "memcached_cluster_cache_nodes" {
  value = module.memcached.cache_nodes
}