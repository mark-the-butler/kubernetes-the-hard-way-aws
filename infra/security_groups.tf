resource "aws_security_group" "allow_external" {
  name        = "External SSH ICMP HTTPS "
  description = "Allows external communication for SSH, ICMP, and HTTPS"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.my_ip]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [local.my_ip]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [local.my_ip]
  }

  tags = {
    Name = "All Internal"
  }
}
