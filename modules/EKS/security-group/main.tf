resource "aws_security_group" "security_group" {
  name        = "${var.cluster_name}-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ports
    iterator = port
    content {
      description     = "TLS from VPC"
      from_port       = port.value
      to_port         = port.value
      protocol        = "tcp"
      prefix_list_ids = []
      security_groups = []
      cidr_blocks     = ["${var.natgateway_public_ip}/32"]
      self            = false
    }
  }

  egress {
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    security_groups  = []
    self             = false
  }
  
  tags = {
    Name = "${var.cluster_name}-sg"
  }
}

