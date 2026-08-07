resource "aws_autoscaling_group" "this" {
  name                = "${var.name_prefix}-${var.environment}-ASG"
  vpc_zone_identifier = var.private_subnet_ids
  target_group_arns   = [var.target_group_arn]
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity

  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.name_prefix}-${var.environment}-Web"
    propagate_at_launch = true
  }
}