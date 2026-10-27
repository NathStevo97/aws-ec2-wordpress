variable "vpc_cidr" {
  type    = string
  default = "10.2.0.0/16"
}

variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "availability_zone_map" {
  type = map(any)
  default = {
    a = 0,
    b = 1,
    c = 2
  }
}
variable "resource_name_prefix" {
  type    = string
  default = "aws-ec2-wordpress"
}

variable "db_name" {
  type        = string
  description = "The database name"
}
variable "db_pass" {
  type        = string
  description = "The database password"
}

variable "db_user" {
  type        = string
  description = "The database user"
}

variable "aws_ami_id" {
  type        = string
  description = "Custom AMI ID by Packer"
}
