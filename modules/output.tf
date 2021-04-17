output "arn" {
  value       = aws_elasticache_replication_group.redis.*.arn
  description = "The Amazon Resource Name (ARN) of the created ElastiCache Replication Group."
}
output "id" {
  value       = aws_elasticache_replication_group.redis.*.id
  description = "The ID of the ElastiCache Replication Group."
}
output "cluster_enabled" {
  value       = aws_elasticache_replication_group.redis.*.cluster_enabled
  description = "Indicates if cluster mode is enabled."
}
output "configuration_endpoint_address" {
  value       = aws_elasticache_replication_group.redis.*.configuration_endpoint_address
  description = "The address of the replication group configuration endpoint when cluster mode is enabled."
}
output "primary_endpoint_address" {
  value       = aws_elasticache_replication_group.redis.*.primary_endpoint_address
  description = "The address of the endpoint for the primary node in the replication group, if the cluster mode is disabled."
}
output "reader_endpoint_address" {
  value       = aws_elasticache_replication_group.redis.*.reader_endpoint_address
  description = "The address of the endpoint for the reader node in the replication group, if the cluster mode is disabled."
}
output "auth_token" {
  value       = random_string.auth_token.*.result
  description = "Create a random string"
}
#....................memcached only..................................
output "configuration_endpoint" {
  value       = aws_elasticache_cluster.memcached.*.configuration_endpoint
  description = "(Memcached only) The configuration endpoint to allow host discovery."
}
output "cluster_address" {
  value       = aws_elasticache_cluster.memcached.*.cluster_address
  description = "(Memcached only) The DNS name of the cache cluster without the port appended."
}
output "cache_nodes" {
  value       = aws_elasticache_cluster.memcached.*.cache_nodes
  description = "List of node objects including id, address, port and availability_zone."
}
output "mem_arn" {
  value       = aws_elasticache_cluster.memcached.*.arn
  description = "The ARN of the created ElastiCache Cluster."
}