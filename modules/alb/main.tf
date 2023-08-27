# Target Group for an app
resource "aws_lb_target_group" "main" {
  name     = var.tg_name
  port     = var.tg_port
  protocol = var.tg_protocol
  vpc_id   = var.vpc_id
}

resource "aws_lb" "my_alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.subnet_ids
}

resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
# Target Group attachment
resource "aws_lb_target_group_attachment" "main" {
  count            = length(var.instance_ids)
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = var.instance_ids[count.index]
}

resource "aws_security_group" "alb" {
  name        = "allow traffic for alb"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.alb_ingress_rules
    content {
      description = "some description"
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "web_security_rules"
  }
}

