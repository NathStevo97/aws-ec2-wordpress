resource "aws_efs_file_system" "wordpress-efs" {
  creation_token = "my_random-wordpress-token"

  tags = {
    Name = "${var.resource_name_prefix}-EFS"
  }

  depends_on = [
    module.vpc
  ]
}

resource "aws_efs_mount_target" "efs-target-a" {
  file_system_id  = aws_efs_file_system.wordpress-efs.id
  security_groups = [aws_security_group.default.id]
  subnet_id       = module.vpc.private_subnets[0]

  depends_on = [
    module.vpc,
    aws_efs_file_system.wordpress-efs
  ]
}

resource "aws_efs_mount_target" "efs-target-b" {
  file_system_id  = aws_efs_file_system.wordpress-efs.id
  security_groups = [aws_security_group.default.id]
  subnet_id       = module.vpc.private_subnets[1]

  depends_on = [
    module.vpc,
    aws_efs_file_system.wordpress-efs
  ]
}

resource "aws_efs_mount_target" "efs-target-c" {
  file_system_id  = aws_efs_file_system.wordpress-efs.id
  security_groups = [aws_security_group.default.id]
  subnet_id       = module.vpc.private_subnets[2]

  depends_on = [
    module.vpc,
    aws_efs_file_system.wordpress-efs
  ]
}
