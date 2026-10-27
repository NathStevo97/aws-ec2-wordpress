resource "aws_key_pair" "default" {
  key_name   = "${var.resource_name_prefix}-key-pair"
  public_key = file(var.public_key_path)
}
