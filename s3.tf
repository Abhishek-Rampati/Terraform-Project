## aws s3 bucket
resource "aws_s3_bucket" "web_bucket" {
  bucket        = local.s3_bucket_name
  

  tags = local.common_tags
}

## aws s3 bucket ACL


resource "aws_s3_bucket_ownership_controls" "web_bucket_oc" {
  bucket = aws_s3_bucket.web_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "my_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.web_bucket_oc]

  bucket = aws_s3_bucket.web_bucket.id
  acl    = "private"
}
## aws s3 bucket object

resource "aws_s3_object" "object" {
  bucket = local.s3_bucket_name
  key    = "/website/index.html"
  source = "./website/index.html"


  tags = local.common_tags
}

resource "aws_s3_object" "image" {
  bucket = local.s3_bucket_name
  key    = "/website/beach.jpg"
  source = "./website/beach.jpg"


  tags = local.common_tags
}
## aws iam role

resource "aws_iam_role" "s3_Access_role" {
  name = "s3_Access_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = local.common_tags

}

## aws iam policy attachement
resource "aws_iam_role_policy" "allow_s3_all" {
  name = "allow_s3_all"
  role = aws_iam_role.s3_Access_role.id


  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "S3:*"
        ],
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}


## aws instance profile
resource "aws_iam_instance_profile" "ngnix_profile" {
  name = "ngnix_profile"
  role = aws_iam_role.s3_Access_role.name

  tags = local.common_tags
}