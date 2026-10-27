module "wordpress" {
  source                = "./modules/wordpress"
  vpc_cidr              = var.vpc_cidr
  region                = var.region
  availability_zone_map = var.availability_zone_map
  resource_name_prefix  = var.resource_name_prefix
  db_name               = var.db_name
  db_pass               = var.db_pass
  db_user               = var.db_user
  aws_ami_id            = var.aws_ami_id
  # tags = {
  #     Name = "${var.resource_name_prefix}-wordpress"
  # }
}
