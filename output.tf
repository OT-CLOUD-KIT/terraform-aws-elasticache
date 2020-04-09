output "configuration_endpoint_address" {
  value = aws_elasticache_replication_group.default.configuration_endpoint_address
}

output "auth_token" {
  value = random_string.auth_token.result
}

