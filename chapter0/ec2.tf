resource "aws_instance" "web" {
  ami                    = "ami-0c1638aa346a43fe8" # Amazon Linux 2 など適切な AMI ID に変更してください
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_1.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = "daijomiho"
  associate_public_ip_address = true
  disable_api_termination     = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl enable httpd
              systemctl start httpd
              echo "Hello from EC2!" > /var/www/html/index.html
              EOF

  tags = {
    Name = "${var.name_prefix}-EC2"
  }
}

resource "aws_lb_target_group_attachment" "ec2_attach" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.web.id
  port             = 8080
}
