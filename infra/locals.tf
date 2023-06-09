locals {
  default_az_id = data.aws_availability_zones.available.zone_ids[0]
}