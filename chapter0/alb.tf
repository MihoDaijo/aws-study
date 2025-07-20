resource "aws_lb" "alb" {
  name               = "${var.name_prefix}-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]

  tags = {
    Name = "${var.name_prefix}-ALB"
  }
}

resource "aws_lb_target_group" "target_group" {
  name     = "${var.name_prefix}-TG-v2"  # ← 名前を変更
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  target_type = "instance"

  health_check {
    path                = "/"
    interval            = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    protocol            = "HTTP"
  }

  tags = {
    Name = "${var.name_prefix}-TG-v2"   # ← タグの名前も合わせて変更
  }
}
