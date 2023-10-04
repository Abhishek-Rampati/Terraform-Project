output "aws_lb_public_dns" {

  value = aws_lb.ngnix.dns_name

}