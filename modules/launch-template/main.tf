data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# Reference the Learner Lab's pre-existing instance profile instead of creating one
data "aws_iam_instance_profile" "lab" {
  name = "LabInstanceProfile"
}

resource "aws_launch_template" "this" {
  name_prefix   = "${var.name_prefix}-${var.environment}-LT-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  iam_instance_profile {
    name = data.aws_iam_instance_profile.lab.name
  }

  vpc_security_group_ids = [var.web_sg_id]

  user_data = base64encode(templatefile("${path.module}/user_data.sh.tpl", {
    bucket_name = var.bucket_name
    image_key   = var.image_key
    environment = var.environment
  }))

  tag_specifications {
    resource_type = "instance"
    tags = { Name = "${var.name_prefix}-${var.environment}-Web" }
  }
}