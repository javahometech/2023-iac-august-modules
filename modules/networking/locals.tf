locals {
  az_names    = data.aws_availability_zones.azs.names
  pri_sub_ids = aws_subnet.private.*.id
}
