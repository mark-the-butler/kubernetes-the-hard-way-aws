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
  security_groups             = [aws_security_group.allow_external.id, aws_security_group.allow_internal.id]
  associate_public_ip_address = true
  private_ip                  = "10.100.10.1${count.index}"
  monitoring                  = true
  key_name                    = aws_key_pair.computer_instances.key_name

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  tags = {
    Name = "K8s-Controller-0${count.index}"
  }
}
