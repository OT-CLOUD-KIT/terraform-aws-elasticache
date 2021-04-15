data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["default"]

  }
}
data "aws_subnet_ids" "subnet_ids" {
  vpc_id = data.aws_vpc.vpc.id
}
data "aws_subnet" "subnet" {
  for_each = data.aws_subnet_ids.subnet_ids.ids
  id       = each.value
}
# output "foo" {
#   value = data.aws_vpc.foo.id
# }
# output "subnet_id" {
#   value = {for s in data.aws_subnet.subnet : s.id => s.cidr_block}
# }
# output "vpc_cidr_blocks" {
#   value = data.aws_vpc.vpc.cidr_block
# }  