locals {
  default_az_id = data.aws_availability_zones.available.zone_ids[0]
  my_ip = "${chomp(data.http.myip.response_body)}/32"
}