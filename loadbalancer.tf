## aws_lb_service_account

data "aws_elb_service_account" "root" {}



## aws_loadbalancer
resource "aws_lb" "ngnix" {
  name               = "Global-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.my-subnets[count.index].id]
  enable_deletion_protection = false



  tags = local.common_tags
}

## aws_lb_target_group

resource "aws_lb_target_group" "ngnix_tg" {
  name     = "ngnix-tg-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my-vpc.id

  tags = local.common_tags
}

## aws_lb_listener

resource "aws_lb_listener" "ngnix" {
  load_balancer_arn = aws_lb.ngnix.arn
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ngnix_tg.arn
  }
}
## aws_lb_listener_attachment

resource "aws_lb_target_group_attachment" "ngnix" {
  count = var.instance_count
  target_group_arn = aws_lb_target_group.ngnix_tg.arn
  target_id        = aws_instance.Demoinstances[count.index].id
  port             = 80
}

/*resource "aws_lb_target_group_attachment" "ngnix2" {
  target_group_arn = aws_lb_target_group.ngnix_tg.arn
  target_id        = aws_instance.Demoinstance2.id
  port             = 80
}*/