resource "aws_security_group" "security_group" {
  name        = "Basic security-group"
  description = "Allow port 80"
  tags        = { Name = "Basic-SG" }
}

resource "aws_vpc_security_group_egress_rule" "example" {
  security_group_id = aws_security_group.security_group.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "example" {
  security_group_id = aws_security_group.security_group.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
}

resource "aws_instance" "web" {
  ami             = "ami-073130f74f5ffb161"
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.security_group.name]
  user_data       = file("userdata.sh")

  tags = {
    Name = "EC2 instance"
  }
}

output "instance_public_ip" {
  value       = aws_instance.web.public_ip
  description = "Website is running on this address:"
}