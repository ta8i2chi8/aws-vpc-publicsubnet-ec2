data "aws_ssm_parameter" "amzn2" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "web_server" {
  ami                         = data.aws_ssm_parameter.amzn2.value
  instance_type               = "t2.micro"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.web_server.id]
  key_name                    = "nginx-web-server-key"
  associate_public_ip_address = true

  tags = {
    Name = "${var.pj_name}-ec2"
  }

  # Nginx
  user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo amazon-linux-extras install nginx1 -y
                sudo yum install nginx -y
                sudo systemctl start nginx
                sudo systemctl enable nginx
              EOF
}

resource "aws_security_group" "web_server" {
  name        = "${var.pj_name}-sg"
  description = "${var.pj_name} sg"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.pj_name}-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "web_server" {
  count = length(var.security_group_ingress_rules)

  security_group_id = aws_security_group.web_server.id
  cidr_ipv4         = var.security_group_ingress_rules[count.index].cidr
  ip_protocol       = "TCP"
  from_port         = var.security_group_ingress_rules[count.index].from_port
  to_port           = var.security_group_ingress_rules[count.index].to_port
}

resource "aws_vpc_security_group_egress_rule" "web_server" {
  security_group_id = aws_security_group.web_server.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
