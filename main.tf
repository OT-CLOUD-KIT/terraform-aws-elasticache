locals {
  tags = { "ENVIRONMENT" : "test", "CLIENT" : "DEVOPS", "PROJECT" : "Demo", "ORGANISATION" : "opstree" }
}

module "redis" {
  source                  = "./modules"
  name                    = "Opstree"
  engine                  = "redis"
  subnet_ids              = ["subnet-2132123","subnet-878746827"]
  security_group_ids      = ["sg-121212121"]
  parameter = [{
    name  = "activerehashing"
    value = "no"},{
    name  = "active-expire-effort"
    value = "2"
  }]
  parameter_group_name = "test"
}
module "memcached" {
  source                   = "./modules"
  name                     = "Opstree"
  engine                   = "memcached"
  subnet_ids               = ["subnet-2132123","subnet-878746827"]
  security_group_ids       = ["sg-121212121"]
}
