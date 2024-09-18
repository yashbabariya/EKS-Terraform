resource "aws_key_pair" "ssh_key" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.rsa.public_key_openssh
}

# RSA key of size 4096 bits
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "tf_key" {
  content         = tls_private_key.rsa.private_key_pem
  filename        = var.key_pair_name
  file_permission = "0600"
}

# resource "aws_instance" "ec2_for_ami" {
#   ami                         = var.aws_launch_template_image_id
#   instance_type               = var.aws_launch_template_instance_type
#   key_name                    = var.key_pair_name
#   security_groups             = [var.asg_security_group_id]
#   associate_public_ip_address = true

#   subnet_id = var.public_subnet_ids[0]

#   tags = {
#     Name = "${var.aws_autoscaling_group_name}-vm"
#   }

#   depends_on = [aws_key_pair.ssh_key, local_file.tf_key]
# }

# resource "aws_ami_from_instance" "ec2_ami" {
#   name               = var.ami_name
#   source_instance_id = aws_instance.ec2_for_ami.id

#   tags = {
#     Name = "${var.aws_autoscaling_group_name}-ami"
#   }

#   depends_on = [aws_instance.ec2_for_ami]
# }

resource "aws_launch_template" "aws_launch_template" {
  name          = "${var.aws_autoscaling_group_name}-launch-template"
  image_id      = var.aws_launch_template_image_id
  instance_type = var.aws_launch_template_instance_type
  user_data     = filebase64("${path.module}/user-data.sh")
  

  key_name = var.key_pair_name

  network_interfaces {
    associate_public_ip_address = true
    device_index    = 0
    security_groups = [var.asg_security_group_id]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.aws_autoscaling_group_name}-vm"
    }
  }

  tags = {
    Name = "${var.aws_autoscaling_group_name}-launch-template"
  }

  depends_on = [aws_key_pair.ssh_key, local_file.tf_key]
}

resource "aws_autoscaling_group" "autoscaling_group" {
  name                = "${var.aws_autoscaling_group_name}-asg"
  min_size            = 3
  max_size            = 3
  desired_capacity    = 3
  vpc_zone_identifier = var.public_subnet_ids

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 80
      max_healthy_percentage = 110
      instance_warmup = 10  
      skip_matching = true
    }
  }

  launch_template {
    id      = aws_launch_template.aws_launch_template.id
    version = aws_launch_template.aws_launch_template.latest_version
  }

  instance_maintenance_policy {
    min_healthy_percentage = 100
    max_healthy_percentage = 110
  }

  depends_on = [aws_launch_template.aws_launch_template]
}

# resource "aws_autoscaling_policy" "target_tracking_policy" {
#   name                   = "${var.aws_autoscaling_group_name}-target-tracking-policy"
#   autoscaling_group_name = aws_autoscaling_group.autoscaling_group.name
#   policy_type            = "TargetTrackingScaling"

#   target_tracking_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ASGAverageCPUUtilization"
#     }
#     target_value = 50.0
#   }

#   depends_on = [aws_autoscaling_group.autoscaling_group]
# }

# resource "null_resource" "ec2_terminate" {
#   provisioner "local-exec" {
#     command = <<EOT
#       sleep 60
#       aws ec2 describe-instances --instance-ids ${aws_instance.ec2_for_ami.id} --query 'Reservations[*].Instances[*].State.Name' --output text
#       if [ $? -eq 0 ]; then
#         aws ec2 terminate-instances --instance-ids ${aws_instance.ec2_for_ami.id}
#       else
#         echo "Instance does not exist or is already terminated."
#       fi
#     EOT
#   }
#   depends_on = [aws_autoscaling_policy.target_tracking_policy, aws_instance.ec2_for_ami]
# }

resource "aws_lb" "network_alb" {
  name               = "${var.aws_autoscaling_group_name}-alb"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.public_subnet_ids
  security_groups    = [var.lb_security_group_id]

  enable_deletion_protection = false

  tags = {
    Name = "${var.aws_autoscaling_group_name}-alb"
  }

  depends_on = [aws_autoscaling_group.autoscaling_group]
}

resource "aws_lb_target_group" "target_group" {
  for_each    = toset(var.target_group_ports)
  name        = "${var.aws_autoscaling_group_name}-tg-${each.value}"
  target_type = "alb"
  port        = each.value
  protocol    = "TCP"
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener" "lb_listener" {
  for_each          = toset(var.target_group_ports)
  load_balancer_arn = aws_lb.network_alb.arn
  port              = each.value
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group[each.key].arn
  }

  depends_on = [aws_lb_target_group.target_group, aws_lb.network_alb]
}
