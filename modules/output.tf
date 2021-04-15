output "arn" {
  value = aws_elasticache_replication_group.redis.arn
}
output "id" {
  value = aws_elasticache_replication_group.redis.id
}
output "configuration_endpoint_address" {
  value = aws_elasticache_replication_group.redis.configuration_endpoint_address
}
output "primary_endpoint_address" {
  value = aws_elasticache_replication_group.redis.primary_endpoint_address
}
output "reader_endpoint_address" {
  value = aws_elasticache_replication_group.redis.reader_endpoint_address
}
output "auth_token" {
  value = random_string.auth_token.result
}