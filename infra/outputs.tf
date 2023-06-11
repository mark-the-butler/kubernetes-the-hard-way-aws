output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "ec2_private_key" {
  value     = tls_private_key.this.private_key_openssh
  sensitive = true
}

output "controller_ips" {
  value = local.controller_ips
}

output "worker_ips" {
  value = local.worker_ips
}
