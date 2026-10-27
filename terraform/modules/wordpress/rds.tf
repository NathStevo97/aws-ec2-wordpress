resource "aws_db_instance" "wordpress" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  db_name                = var.db_name
  username               = var.db_user
  password               = var.db_pass
  parameter_group_name   = aws_db_parameter_group.default.name
  db_subnet_group_name   = aws_db_subnet_group.private.name
  vpc_security_group_ids = [aws_security_group.default.id]
  skip_final_snapshot    = true
}

resource "aws_db_subnet_group" "private" {
  name       = "main"
  subnet_ids = module.vpc.private_subnets
  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_parameter_group" "default" {
  name   = "${var.db_name}-pg"
  family = "mysql5.7"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }

  lifecycle {
    create_before_destroy = true
  }
}
