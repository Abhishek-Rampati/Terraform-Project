resource "aws_instance" "Demoinstances" {
  count = var.instance_count
  ami           = "ami-051f7e7f6c2f40dc1"
  instance_type = var.instance_type
  subnet_id              = aws_subnet.my-subnets[count.index].id
  vpc_security_group_ids = [aws_security_group.ngnix-sg.id]
  iam_instance_profile = aws_iam_instance_profile.ngnix_profile.name
  depends_on           = [aws_iam_role.s3_Access_role]

  tags = local.common_tags

}

/*resource "aws_instance" "Demoinstance2" {
  ami           = "ami-051f7e7f6c2f40dc1"
  instance_type = var.instance_type

  subnet_id              = aws_subnet.my-subnet2.id
  vpc_security_group_ids = [aws_security_group.ngnix-sg.id]

  iam_instance_profile = aws_iam_instance_profile.ngnix_profile.name
  depends_on           = [aws_iam_role.s3_Access_role]

  tags = local.common_tags

}*/