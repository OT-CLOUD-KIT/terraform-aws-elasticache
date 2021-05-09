locals {
  tags = { "ENVIRONMENT" : "test", "CLIENT" : "DEVOPS", "PROJECT" : "Demo", "ORGANISATION" : "opstree" }
}

module "redis" {
  source                  = "./modules"
  name                    = "Opstree"
  engine                  = "redis"
}
module "memcached" {
  source                   = "./modules"
  name                     = "Opstree"
  engine                   = "memcached"
}
