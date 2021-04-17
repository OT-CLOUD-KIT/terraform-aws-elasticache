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
