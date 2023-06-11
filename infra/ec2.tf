locals {
  controller_ips = {
    for instance in aws_instance.controllers :
    instance.tags.Name => {
      public_ip  = instance.public_ip,
      private_ip = instance.private_ip
    }
  }

  worker_ips = {
    for instance in aws_instance.workers :
    instance.tags.Name => {
      public_ip  = instance.public_ip,
      private_ip = instance.private_ip
    }
  }

  static_ip = aws_eip.load_balancer.public_ip
}

variable "revision" {
  default = 1
}

resource "terraform_data" "revision" {
  input = var.revision
}

resource "terraform_data" "generate_certs" {
  triggers_replace = terraform_data.revision
  provisioner "local-exec" {
    interpreter = [ "/bin/bash", "-c" ]
    command = "./PKI/generate_certs.sh '${jsonencode(local.worker_ips)}' ${local.static_ip}"
  }
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "computer_instances" {
  key_name   = ""
  public_key = tls_private_key.this.public_key_openssh
}

resource "aws_instance" "controllers" {
  count = 3

  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.main_public.id
  vpc_security_group_ids      = [aws_security_group.allow_external.id, aws_security_group.allow_internal.id]
  associate_public_ip_address = true
  private_ip                  = "10.100.10.1${count.index}"
  monitoring                  = true
  key_name                    = aws_key_pair.computer_instances.key_name

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  tags = {
    Name = "controller-${count.index}"
  }
}

resource "aws_instance" "workers" {
  count = 3

  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.main_public.id
  vpc_security_group_ids      = [aws_security_group.allow_external.id, aws_security_group.allow_internal.id]
  associate_public_ip_address = true
  private_ip                  = "10.100.10.2${count.index}"
  monitoring                  = true
  key_name                    = aws_key_pair.computer_instances.key_name

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  tags = {
    Name = "worker-${count.index}"
  }
}
