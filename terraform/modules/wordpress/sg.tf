resource "aws_security_group" "default" {
  name        = "${var.resource_name_prefix}-default-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = module.vpc.vpc_id
  ingress {
    description = "Allow All Ingress"
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    self        = true
  }

  ingress {
    description = "Explicitly Allow SSH Access" # Not recommended long-term
    from_port   = "22"
    to_port     = "22"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "80 from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow Egress Everywhere"
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Environment = var.resource_name_prefix
    Name        = "${var.resource_name_prefix}-security-group"
  }
}
