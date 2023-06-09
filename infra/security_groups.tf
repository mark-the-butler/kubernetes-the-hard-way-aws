resource "aws_security_group" "allow_external" {
  name        = "External SSH ICMP HTTPS"
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
    Name = "External SSH ICMP HTTPS"
  }
}

resource "aws_security_group" "allow_internal" {
  name        = "Internal All"
  description = "Allows internal communication for all TCP, UDP, and ICMP"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block, aws_subnet.main_public.cidr_block]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = [aws_vpc.main.cidr_block, aws_subnet.main_public.cidr_block]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [aws_vpc.main.cidr_block, aws_subnet.main_public.cidr_block]
  }

  tags = {
    Name = "All External"
  }
}

resource "aws_security_group" "allow_outbound" {
  name        = "Outbound All"
  description = "Allows outbound communication to the internet."
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Outbound All"
  }
}
