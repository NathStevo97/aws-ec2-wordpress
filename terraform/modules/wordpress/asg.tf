# Collection of EC2 Instances for autoscaling purposes
resource "aws_autoscaling_group" "web-server" {
  name                 = "${var.resource_name_prefix}-asg"
  max_size             = 3
  min_size             = 1
  desired_capacity     = 2
  force_delete         = true
  launch_configuration = aws_launch_configuration.web-server-launch-config.name
  vpc_zone_identifier  = module.vpc.public_subnets
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      load_balancers, target_group_arns
    ]
  }
  tag {
    key                 = "Name"
    value               = "nginx-web-server-asg"
    propagate_at_launch = true
  }
  timeouts {
    delete = "15m"
  }
}

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "nginx-alb" {
  autoscaling_group_name = aws_autoscaling_group.web-server.id
  lb_target_group_arn    = aws_lb_target_group.nginx-alb.arn
}

# Initial configuration for all EC2 instances in the group
## Metadata, specs, user data / scripts, etc.
resource "aws_launch_configuration" "web-server-launch-config" {
  name = "${var.resource_name_prefix}-web_config"
  #image_id      = data.aws_ami.ubuntu.id
  image_id      = var.aws_ami_id
  instance_type = "t2.micro"
  user_data = templatefile("${path.module}/userdata.tpl", {
    db_name = var.db_name
    db_pass = var.db_pass
    db_user = var.db_user
    db_host = aws_db_instance.wordpress.address
    efs_id  = aws_efs_file_system.wordpress-efs.id
  })
  security_groups = [aws_security_group.default.id]
  key_name        = aws_key_pair.default.id
  lifecycle {
    create_before_destroy = true
  }
}
