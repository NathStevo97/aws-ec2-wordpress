module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.5.1"

  name = "${var.resource_name_prefix}-vpc"

  cidr = var.vpc_cidr

  azs = formatlist("%s%s", var.region, keys(var.availability_zone_map))

  private_subnets = [for n in toset(values(var.availability_zone_map)) : cidrsubnet(var.vpc_cidr, 8, tonumber(n) + 128)]

  public_subnets = [for n in toset(values(var.availability_zone_map)) : cidrsubnet(var.vpc_cidr, 8, tonumber(n))]

  enable_dns_hostnames    = true
  enable_dns_support      = true
  map_public_ip_on_launch = true

  enable_nat_gateway = true
  single_nat_gateway = true
}
