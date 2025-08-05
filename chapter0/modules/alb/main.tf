resource "aws_lb" "alb" {
  name               = "${var.name_prefix}-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids
  ip_address_type    = "ipv4"

  tags = {
    Name = "${var.name_prefix}-ALB"
  }
}

resource "aws_lb_target_group" "target_group" {
  name     = "${var.name_prefix}-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    interval            = 30
    protocol            = "HTTP"
    matcher             = "200"
  }

  tags = {
    Name = "${var.name_prefix}-TG"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_lb_target_group_attachment" "attach" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = var.instance_id
  port             = 80
}
