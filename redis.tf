resource "aws_elasticache_replication_group" "redis" {
  replication_group_id          = "${var.project_environment}"
  description                   = "${var.project_environment} valkey cluster"
  count                         = var.redis_cluster_count > 0 ? 1 : 0
  engine                        = "valkey"
  apply_immediately             = var.redis_apply_immediately
  subnet_group_name             = aws_elasticache_subnet_group.redis_subnet[0].name
  node_type                     = var.redis_node_type
  num_cache_clusters            = var.redis_cluster_count
  engine_version                = var.redis_engine_version
  parameter_group_name          = var.redis_parameter_group_name
  automatic_failover_enabled    = false
  port                          = 6379
  security_group_ids            = [aws_security_group.production-redis[0].id]
}

resource "aws_elasticache_subnet_group" "redis_subnet" {
  count      = var.redis_cluster_count > 0 ? 1 : 0
  name       = "${var.project_environment}-cache-subnet"
  subnet_ids = data.aws_subnets.subnets.ids
}

resource "aws_security_group" "production-redis" {
  count       = var.redis_cluster_count > 0 ? 1 : 0
  name        = "${var.project_environment}-redis"
  description = "${var.project_environment}-redis"
  vpc_id      = aws_vpc.production-internal.id

  ingress {
    description      = "Redis traffic from webservers and workers"
    from_port        = 6379
    to_port          = 6379
    protocol         = "tcp"
    security_groups  = [aws_security_group.production-webservers.id, aws_security_group.production-workers.id]
  }
}
